inputs:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = import ../packages.nix {
    inherit pkgs lib;
    exclude_packages = config.omarchy.exclude_packages;
  };

  themes = import ../themes.nix;

  # Handle theme selection - either predefined or generated
  selectedTheme =
    if (config.omarchy.theme == "generated_light" || config.omarchy.theme == "generated_dark") then
      null
    else
      themes.${config.omarchy.theme};

  # Generate color scheme from wallpaper for generated themes
  generatedColorScheme =
    if (config.omarchy.theme == "generated_light" || config.omarchy.theme == "generated_dark") then
      (inputs.nix-colors.lib.contrib { inherit pkgs; }).colorSchemeFromPicture {
        path = config.omarchy.theme_overrides.wallpaper_path;
        variant = if config.omarchy.theme == "generated_light" then "light" else "dark";
      }
    else
      null;
in
{
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

  colorScheme =
    if (config.omarchy.theme == "generated_light" || config.omarchy.theme == "generated_dark") then
      generatedColorScheme
    else
      inputs.nix-colors.colorSchemes.${selectedTheme.base16-theme};

  gtk = {
    enable = true;
    theme = {
      name = if config.omarchy.theme == "generated_light" then "Adwaita" else "Adwaita:dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  # TODO: Add an actual nvim config
  programs.neovim.enable = true;
}
