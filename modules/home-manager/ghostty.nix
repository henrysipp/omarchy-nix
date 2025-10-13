{
  config,
  pkgs,
  ...
}:
let
  cfg = config.omarchy;
  palette = config.colorScheme.palette;
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      # Window settings
      window-padding-x = 14;
      window-padding-y = 14;
      background-opacity = 0.95;
      window-decoration = "none";

      font-family = cfg.primary_font;
      font-size = 12;

      theme = "omarchy";
      keybind = [
        "ctrl+k=reset"
      ];
    };
    themes = {
      omarchy = {
        background = "#${palette.base00}";
        foreground = "#${palette.base05}";

        selection-background = "#${palette.base02}";
        selection-foreground = "#${palette.base00}";
        palette = [
          "0=#${palette.base00}"
          "1=#${palette.base08}"
          "2=#${palette.base0B}"
          "3=#${palette.base0A}"
          "4=#${palette.base0D}"
          "5=#${palette.base0E}"
          "6=#${palette.base0C}"
          "7=#${palette.base05}"
          "8=#${palette.base03}"
          "9=#${palette.base08}"
          "10=#${palette.base0B}"
          "11=#${palette.base0A}"
          "12=#${palette.base0D}"
          "13=#${palette.base0E}"
          "14=#${palette.base0C}"
          "15=#${palette.base07}"
          "16=#${palette.base09}"
          "17=#${palette.base0F}"
          "18=#${palette.base01}"
          "19=#${palette.base02}"
          "20=#${palette.base04}"
          "21=#${palette.base06}"
        ];
      };
    };
  };
}
