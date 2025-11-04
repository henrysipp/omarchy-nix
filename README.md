# Omarchy Nix

Omarchy-nix (Omanix?) is an opinionated NixOS flake to help you get started as fast as possible with NixOS and Hyprland. It is primarily a reimplementation of [DHH's Omarchy](https://github.com/basecamp/omarchy) project - an opinionated Arch/Hyprland setup for modern web development.

__This isn't meant to be full feature parity with Omarchy and likely never will be, especially with how fast the feature development and funding has been for that project. Instead, think of this as more of a launch pad to get your own similar Nix config set up!__

## Quick Start

To get started you'll first need to set up a fresh [NixOS](https://nixos.org/) install. Just download and create a bootable USB and you should be good to go.


Once ready, add this flake to your system configuration, you'll also need [home-manager](https://github.com/nix-community/home-manager) as well:
(You can find my personal nix setup [here](https://github.com/henrysipp/nix-setup) too if you need a reference.)
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    omarchy-nix = {
        url = "github:henrysipp/omarchy-nix";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, omarchy-nix, home-manager, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      modules = [
        omarchy-nix.nixosModules.default
        home-manager.nixosModules.home-manager #Add this import
        {
          # Configure omarchy
          omarchy = {
            full_name = "Your Name";
            email_address = "your.email@example.com";
            theme = "tokyo-night";
          };
          
          home-manager = {
            users.your-username = {
              imports = [ omarchy-nix.homeManagerModules.default ]; # And this one
            };
          };
        }
      ];
    };
  };
}
```

## Configuration Options

I've specified some basic configuration options to help you get started with initial setup, as well as some simple overrides for common configuration settings I found I was modifying often. These are likely subject to change with future versions as I iron things out.

Refer to [the root configuration](https://github.com/henrysipp/omarchy-nix/blob/main/config.nix) file for more information on what options are available.

### Themes

Omarchy-nix includes several predefined themes:
- `tokyo-night` (default)
- `kanagawa`
- `everforest`
- `catppuccin`
- `nord`
- `gruvbox`
- `gruvbox-light`

You can also generate themes from wallpaper images using:
- `generated_light` - generates a light color scheme from wallpaper
- `generated_dark` - generates a dark color scheme from wallpaper

Generated themes require a wallpaper path to be specified:

```nix
{
  omarchy = {
    theme = "generated_dark"; # or "generated_light"
    theme_overrides = {
      wallpaper_path = ./path/to/your/wallpaper.png;
    };
  };
}
```

#### Wallpaper Overrides

Any theme can be customized with a custom wallpaper by specifying `wallpaper_path` in theme_overrides. For predefined themes, this will only change the wallpaper but keep the original color scheme:

```nix
{
  omarchy = {
    theme = "tokyo-night"; # or any other predefined theme
    theme_overrides = {
      wallpaper_path = ./path/to/your/wallpaper.png;
    };
  };
}
```

Generated themes automatically extract colors from the wallpaper and create a matching color scheme for all Omarchy applications (terminal, editor, launcher, etc.). 

## Features

### Control Menu (Super + Alt + Space)

Omarchy-nix includes an enhanced control menu accessible via `Super + Alt + Space` with the following features:

- **Capture**: Screenshots (region/window/monitor), screen recording, color picker
- **Style**: Theme management, wallpaper switching, night light toggle
- **Install**: System updates, package search, garbage collection
- **System**: Lock/suspend/shutdown, Hyprland/Waybar restart
- **Monitors**: Display information and configuration
- **Audio**: Volume control, device management, mute toggle
- **Files**: Quick access to file manager
- **Web Apps**: Enhanced webapp launcher with installation and management

### Web App Launcher

The web apps feature allows you to install and manage Progressive Web Apps (PWAs) as native applications:

- Install custom web apps with name, URL, and icon
- Quick install popular apps (ChatGPT, Gmail, Spotify, etc.)
- List and remove installed web apps
- Launch web apps from the control menu

## Advanced Configuration

For more control over omarchy behavior, you can create a separate home-manager configuration file. See `examples/omarchy-home.nix` for a complete example.

Key configuration options:

```nix
{
  # Choose your color scheme
  colorScheme = inputs.omarchy-nix.inputs.nix-colors.colorSchemes.kanagawa;
  
  # Enable/disable specific programs
  programs = {
    zoxide.enable = true;
    zoxide.enableZshIntegration = lib.mkDefault false;  # Prevent conflicts
    starship.enable = true;
    btop.enable = true;
  };
  
  # Override GTK theme if needed
  gtk.theme.name = lib.mkForce "adw-gtk3";
  gtk.theme.package = lib.mkForce pkgs.adw-gtk3;
}
```

## License

This project is released under the MIT License, same as the original Omarchy.
