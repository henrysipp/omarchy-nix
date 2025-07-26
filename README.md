# Omarchy Nix

Omarchy-nix (Omanix?) is an opinionated NixOS flake to help you get started as fast as possible with NixOS and Hyprland. It is primarily a reimplementation of [DHH's Omarchy](https://github.com/basecamp/omarchy) project - an opinionated Arch/Hyprland setup for modern web development.

This was mostly spun up in a weekend so if you have any issues please let me know, my goal is to eventually make this as seamless an install experience as Omarchy itself!


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

You can also generate a custom theme from any wallpaper image:

```nix
{
  omarchy = {
    theme = "custom";
    customTheme = {
      wallpaperPath = ./path/to/your/wallpaper.png;
      variant = "dark"; # or "light" for light themes
    };
  };
}
```

This will automatically extract colors from your wallpaper and generate a matching color scheme for all Omarchy applications (terminal, editor, launcher, etc.). 

## License

This project is released under the MIT License, same as the original Omarchy.
