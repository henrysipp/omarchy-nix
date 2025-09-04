inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.omarchy;

  #####
  # We have to overide some of the bin files and this is really ugly..
  #####

  # Files to exclude from the bin directory (we provide our own overrides)
  excludedBinFiles = [
    "omarchy-theme-bg-next"
  ];

  # Get all bin files except the ones we want to override
  binDir = ../../omarchy-arch/bin;
  binFiles = builtins.attrNames (builtins.readDir binDir);
  filteredBinFiles = builtins.filter (name: !(builtins.elem name excludedBinFiles)) binFiles;

  # Create source paths for filtered bin files
  binFileSources =
    map (fileName: {
      source = binDir + "/${fileName}";
      target = ".local/share/omarchy/bin/${fileName}";
      executable = true;
    })
    filteredBinFiles;
in {
  home.file = builtins.listToAttrs (map (entry: {
      name = entry.target;
      value = builtins.removeAttrs entry ["target"];
    }) ([
        {
          source = ../../omarchy-arch/default;
          target = ".local/share/omarchy/default";
          recursive = true;
        }
        {
          source = ../../omarchy-arch/logo.txt;
          target = ".local/share/omarchy/logo.txt";
        }
        {
          source = ../../omarchy-arch/themes;
          target = ".config/omarchy/themes";
          recursive = true;
        }
        {
          source = ../../bin/omarchy-theme-bg-next;
          target = ".local/share/omarchy/bin/omarchy-theme-bg-next";
          executable = true;
        }
        # {
        #   source = ../../bin/omarchy-cmd-screenrecord;
        #   target = ".local/share/omarchy/bin/omarchy-cmd-screenrecord";
        #   executable = true;
        # }
      ]
      ++ binFileSources));

  home.sessionPath = [
    ".local/share/omarchy/bin"
  ];
  # Create initial theme symlinks
  home.activation.system-link-default-theme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create necessary directories
    mkdir -p "${config.xdg.configHome}/omarchy/current"
    mkdir -p "${config.xdg.configHome}/btop/themes"
    mkdir -p "${config.xdg.configHome}/mako"
    mkdir -p "${config.xdg.configHome}/nvim/lua/plugins"

    # Define paths
    THEMES_DIR="${config.xdg.configHome}/omarchy/themes"
    CURRENT_THEME_DIR="${config.xdg.configHome}/omarchy/current/theme"
    SELECTED_THEME="${cfg.theme}"
    THEME_PATH="$THEMES_DIR/$SELECTED_THEME"

    # Only create theme symlink if current theme directory doesn't exist
    # This allows user theme changes to persist if they've changed it outside of nix
    if [[ ! -L "$CURRENT_THEME_DIR" ]]; then
      echo "Linking theme: $SELECTED_THEME"

      # Check if the selected theme exists
      if [[ -d "$THEME_PATH" ]]; then
        # Create the main theme symlink
        $DRY_RUN_CMD ln -nsf "$THEME_PATH" "$CURRENT_THEME_DIR"

        # Create specific app symlinks for current theme if they exist
        if [[ -f "$THEME_PATH/neovim.lua" ]]; then
          $DRY_RUN_CMD ln -nsf "$CURRENT_THEME_DIR/neovim.lua" "${config.xdg.configHome}/nvim/lua/plugins/theme.lua"
        fi

        if [[ -f "$THEME_PATH/btop.theme" ]]; then
          $DRY_RUN_CMD ln -nsf "$CURRENT_THEME_DIR/btop.theme" "${config.xdg.configHome}/btop/themes/current.theme"
        fi

        if [[ -f "$THEME_PATH/mako.ini" ]]; then
          $DRY_RUN_CMD ln -nsf "$CURRENT_THEME_DIR/mako.ini" "${config.xdg.configHome}/mako/config"
        fi

        # Create background symlink if theme has backgrounds and no current background exists
        BACKGROUNDS_DIR="$CURRENT_THEME_DIR/backgrounds"
        CURRENT_BACKGROUND_LINK="${config.xdg.configHome}/omarchy/current/background"

        if [[ -d "$BACKGROUNDS_DIR" ]] && [[ ! -L "$CURRENT_BACKGROUND_LINK" ]]; then
          # Find the first background file in the backgrounds directory
          FIRST_BACKGROUND=$(find "$BACKGROUNDS_DIR" -type l \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | sort | head -n 1)

          if [[ -n "$FIRST_BACKGROUND" ]]; then
            echo "Creating initial background symlink: $(basename "$FIRST_BACKGROUND")"
            $DRY_RUN_CMD ln -nsf "$FIRST_BACKGROUND" "$CURRENT_BACKGROUND_LINK"
          fi
        fi

        echo "Theme $SELECTED_THEME linked successfully"
      else
        echo "Warning: Theme '$SELECTED_THEME' not found at $THEME_PATH"
      fi
    else
      echo "Theme $SELECTED_THEME already linked correctly"
    fi
  '';
  home.packages = [
    # needed for omarchy-menu-keybindings
    pkgs.jq
  ];
}
