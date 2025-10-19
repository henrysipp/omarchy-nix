{
  imports = [
    ./lsp.nix
    ./plugins.nix
  ];

  programs.nixvim = {
    enable = true;
  };
}
