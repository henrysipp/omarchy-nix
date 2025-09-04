{
  config,
  pkgs,
  ...
}: let
  cfg = config.omarchy;
in {
  services.mako = {
    enable = true;
  };
}
