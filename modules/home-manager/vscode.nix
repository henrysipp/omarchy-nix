{
  config,
  pkgs,
  ...
}:
let
  cfg = config.omarchy;
  themes = import ../themes.nix;
  theme = themes.${cfg.theme};
in
{
  programs.vscode = {
    enable = true;
    profiles.default = {

      # This is actually turning out to be super annoying whenever I need
      # to change settings on the fly. Disabling until I have time to research.
      # In the meantime themes are broken
      # userSettings =
      # {
      #   "workbench.colorTheme" = theme.vscode-theme;
      #   "vim.useCtrlKeys" = false;
      #   "editor.minimap.enabled" = false;
      # }

      # // cfg.vscode_settings;

      extensions =
        with pkgs.vscode-extensions;
        [
          bbenoist.nix
          vscodevim.vim
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "everforest";
            publisher = "sainnhe";
            version = "0.3.0";
            sha256 = "sha256-nZirzVvM160ZTpBLTimL2X35sIGy5j2LQOok7a2Yc7U=";
          }
          {
            name = "tokyo-night";
            publisher = "enkia";
            version = "1.1.2";
            sha256 = "sha256-oW0bkLKimpcjzxTb/yjShagjyVTUFEg198oPbY5J2hM=";
          }
          {
            name = "kanagawa";
            publisher = "qufiwefefwoyn";
            version = "1.5.1";
            sha256 = "sha256-AGGioXcK/fjPaFaWk2jqLxovUNR59gwpotcSpGNbj1c=";
          }
          {
            name = "nord-visual-studio-code";
            publisher = "arcticicestudio";
            version = "0.19.0";
            sha256 = "sha256-awbqFv6YuYI0tzM/QbHRTUl4B2vNUdy52F4nPmv+dRU=";
          }
          {
            name = "gruvbox";
            publisher = "jdinhlife";
            version = "1.28.0";
            sha256 = "sha256-XwQzbbZU6MfYcT50/0YgQp8UaOeQskEvEQPZXG72lLk=";
          }
        ];
    };
  };
}
