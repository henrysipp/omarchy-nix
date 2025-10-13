{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    zplug = {
      enable = true;
      plugins = [
        {
          name = "plugins/git";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "fdellwing/zsh-bat";
          tags = [ "as:command" ];
        }
      ];
    };
  };
}
