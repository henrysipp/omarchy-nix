{ ... }:
{
  programs = {
    _1password.enable = true;
    _1password-gui.enable = true;

    # TODO: Dynamically get user names
    _1password-gui.polkitPolicyOwners = [ "henry" ];
  };
}
