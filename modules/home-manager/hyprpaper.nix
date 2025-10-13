{
  config,
  pkgs,
  ...
}:
let
  selected_wallpaper_path = (import ../../lib/selected-wallpaper.nix config).wallpaper_path;
in
{
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../config/themes/wallpapers;
      recursive = true;
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        selected_wallpaper_path
      ];
      wallpaper = [
        ",${selected_wallpaper_path}"
      ];
    };
  };
}
