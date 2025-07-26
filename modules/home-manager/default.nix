inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  packages = import ../packages.nix {inherit pkgs lib; exclude_packages = config.omarchy.exclude_packages;};

  themes = import ../themes.nix;
  
  # Handle theme selection - either predefined or custom
  selectedTheme = if config.omarchy.theme == "custom"
    then themes.custom
    else themes.${config.omarchy.theme};
  
  # Generate color scheme - either from predefined or from wallpaper
  generatedColorScheme = if config.omarchy.theme == "custom"
    then (inputs.nix-colors.lib.contrib { inherit pkgs; }).colorSchemeFromPicture {
      path = config.omarchy.customTheme.wallpaperPath;
      variant = config.omarchy.customTheme.variant;
    }
    else null;
in {
  imports = [
    (import ./hyprland.nix inputs)
    (import ./hyprlock.nix inputs)
    (import ./hyprpaper.nix)
    (import ./hypridle.nix)
    (import ./ghostty.nix)
    (import ./btop.nix)
    (import ./direnv.nix)
    (import ./git.nix)
    (import ./mako.nix)
    (import ./starship.nix)
    (import ./vscode.nix)
    (import ./waybar.nix inputs)
    (import ./wofi.nix)
    (import ./zoxide.nix)
    (import ./zsh.nix)
  ];

  home.file = {
    ".local/share/omarchy/bin" = {
      source = ../../bin;
      recursive = true;
    };
  };
  home.packages = packages.homePackages;

  colorScheme = if config.omarchy.theme == "custom"
    then generatedColorScheme
    else inputs.nix-colors.colorSchemes.${selectedTheme.base16-theme};

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  # TODO: Add an actual nvim config
  programs.neovim.enable = true;
}
