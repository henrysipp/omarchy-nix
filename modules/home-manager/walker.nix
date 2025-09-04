{...}: {
  # Walker configuration
  home.file = {
    ".config/walker" = {
      source = ../../omarchy-arch/config/walker;
      recursive = true;
    };
  };
  programs.walker = {
    enable = true;
    runAsService = true;
  };
}
