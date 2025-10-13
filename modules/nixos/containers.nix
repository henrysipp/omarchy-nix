{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation = {
    docker.enable = true;
    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    #   dockerSocket.enable = true;
    #   defaultNetwork.settings.dns_enabled = true;
    # };
  };
}
