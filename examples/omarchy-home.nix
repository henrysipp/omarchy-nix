{ inputs, config, lib, pkgs, osConfig ? {}, ... }:

{
  # Example omarchy home-manager configuration
  # This file shows how to configure omarchy-nix with additional customization
  # 
  # Usage:
  # 1. Copy this file to your hosts/common/ directory
  # 2. Import it in your home-manager configuration
  # 3. Customize the settings below to match your preferences
  
  imports = [
    # Import nix-colors for theming
    # This provides colorScheme options used by omarchy modules
    inputs.omarchy-nix.inputs.nix-colors.homeManagerModules.default
  ];
  
  # Theme Configuration
  # ==================
  # Choose from available nix-colors schemes:
  # - kanagawa (warm, earthy Japanese-inspired theme)
  # - tokyo-night (popular dark theme with vibrant colors)
  # - nord (cool, bluish minimalist theme)
  # - gruvbox (retro warm theme)
  # - catppuccin-* (multiple variants: latte, frappe, macchiato, mocha)
  # - dracula
  # - everforest
  # And many more! See: https://github.com/tinted-theming/schemes
  colorScheme = inputs.omarchy-nix.inputs.nix-colors.colorSchemes.kanagawa;
  
  # Program Configuration
  # ====================
  # Enable/disable omarchy programs that don't conflict with existing setup
  programs = {
    # Zoxide - smart cd replacement
    zoxide = {
      enable = true;
      # Use mkDefault false to prevent conflicts if you have existing ZSH config
      enableZshIntegration = lib.mkDefault false;
    };
    
    # Starship - minimal, fast prompt
    starship = {
      enable = true;
      # Let your existing ZSH config handle integration
      enableZshIntegration = lib.mkDefault false;
    };
    
    # Btop - resource monitor with omarchy theming
    btop = {
      enable = true;
      # Theme will be automatically configured by nix-colors
    };
    
    # Wofi - application launcher (required for omarchy scripts)
    wofi.enable = true;
  };
  
  # Services Configuration
  # =====================
  services = {
    # Mako - notification daemon with omarchy theming
    mako = {
      enable = true;
      # Styling is handled automatically by nix-colors
    };
  };
  
  # GTK Theme Override (Optional)
  # ============================
  # If you want to preserve your existing GTK theme instead of using
  # omarchy's default, uncomment and customize these lines:
  #
  # gtk.theme.name = lib.mkForce "adw-gtk3";
  # gtk.theme.package = lib.mkForce pkgs.adw-gtk3;
  
  # Additional Customization
  # =======================
  # You can add any other home-manager configuration here
  # Examples:
  #
  # home.packages = with pkgs; [
  #   # Add extra packages here
  # ];
  #
  # wayland.windowManager.hyprland.settings = {
  #   # Add extra Hyprland settings here
  # };
  
  # Notes
  # =====
  # - Control menu (Super+Alt+Space) and webapp launcher are automatically included
  # - All omarchy keybindings are set up by default
  # - Packages like hyprshot, hyprpicker, gammastep are included automatically
  # - If you need to exclude specific omarchy packages, use the exclude_packages
  #   option in your NixOS configuration (see main omarchy config)
}
