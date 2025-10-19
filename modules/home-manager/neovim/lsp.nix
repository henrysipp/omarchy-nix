{
  programs.nixvim = {
    plugins.lspconfig.enable = true;
    lsp = {
      inlayHints.enable = true;
      servers = {
        clangd.enable = true;
        lua_ls = {
          enable = true;
          config.settings.diagnostics.globals = [ "vim" ];
        };
        rust_analyzer.enable = true;
      };

      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gD";
          lspBufAction = "references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          key = "<F2>";
          lspBufAction = "rename";
        }
      ];
    };
  };
}
