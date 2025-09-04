{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.omarchy;
in {
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./envs.nix
    ./input.nix
    ./looknfeel.nix
    ./windows.nix
  ];
  wayland.windowManager.hyprland.settings = {
    source = "~/.local/share/omarchy/default/hypr/bindings.conf";

    # Default applications
    "$terminal" = lib.mkDefault "uwsm app -- ghostty";
    "$fileManager" = lib.mkDefault "uwsm app -- nautilus --new-window";
    "$browser" = lib.mkDefault "uwsm app -- chromium --new-window --ozone-platform=wayland";
    "$music" = lib.mkDefault "uwsm app --spotify";
    "$passwordManager" = lib.mkDefault "uwsm app --1password";
    "$messenger" = lib.mkDefault "uwsm app -- signal-desktop";
    "$webapp" = lib.mkDefault "$browser --app";

    monitor = cfg.monitors;
  };
}
