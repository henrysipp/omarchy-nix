inputs: {config, ...}: {
  home.file = {
    "${config.xdg.configHome}/waybar/" = {
      source = ../../omarchy-arch/config/waybar;
      recursive = true;
    };
  };

  programs.waybar = {
    enable = true;
  };
}
