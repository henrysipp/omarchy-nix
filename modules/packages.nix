{
  pkgs,
  lib,
  exclude_packages ? [],
}: let
  # Custom satty package using the latest source from GitHub
  # The default version of satty is 0.18.1, doesn't work with omarchy-cmd-screenshot
  # it is missing --actions-on-enter but has --action-on-enter
  satty-latest = pkgs.satty.overrideAttrs (oldAttrs: rec {
    version = "0.19.0";
    src = pkgs.fetchFromGitHub {
      owner = "gabm";
      repo = "Satty";
      rev = "v0.19.0";
      hash = "sha256-AKzTDBKqZuZfEgPJqv8I5IuCeDkD2+fBY44aAPFaYvI=";
    };
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "${oldAttrs.pname}-${version}";
      hash = "sha256-hvJOjWD5TRXlDr5KfpFlzAi44Xd6VuaFexXziXgDLCk=";
    };
  });

  # Essential Hyprland packages - cannot be excluded
  hyprlandPackages = with pkgs; [
    hyprshot
    hyprpicker
    hyprsunset
    brightnessctl
    pamixer
    playerctl
    gnome-themes-extra
    pavucontrol
    wl-clipboard
    glib
  ];

  # Essential system packages - cannot be excluded
  systemPackages = with pkgs; [
    git
    vim
    libnotify
    nautilus
    alejandra
    blueberry
    clipse
    fzf
    zoxide
    ripgrep
    eza
    fd
    curl
    unzip
    wget
    gnumake
    glib
  ];

  # Discretionary packages - can be excluded by user
  discretionaryPackages = with pkgs; [
    # TUIs
    lazygit
    lazydocker
    btop
    powertop
    fastfetch

    # GUIs
    chromium
    obsidian
    vlc
    signal-desktop

    # Commercial GUIs
    typora
    dropbox
    spotify

    # Development tools
    github-desktop
    gh

    # Containers
    docker-compose
    ffmpeg
  ];

  # Only allow excluding discretionary packages to prevent breaking the system
  filteredDiscretionaryPackages = lib.lists.subtractLists exclude_packages discretionaryPackages;
  allSystemPackages = hyprlandPackages ++ systemPackages ++ filteredDiscretionaryPackages;
in {
  # Regular packages
  systemPackages = allSystemPackages;

  homePackages = [
    satty-latest
  ];
}
