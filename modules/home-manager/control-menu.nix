{ config, pkgs, lib, ... }:

{
  home.file = {
    # Omarchy Control Menu Script
    ".local/bin/omarchy-control-menu" = {
      text = ''
        #!/usr/bin/env bash
        # Omarchy Control Menu - Super + Alt + Space
        
        MENU_OPTIONS="󰄀 Capture
🎨 Style  
📦 Install
⚙️  System
📋 Keybindings
🖥️  Monitors
🔊 Audio
📁 Files
🌐 Web Apps
❌ Cancel"
        
        CHOICE=$(echo "$MENU_OPTIONS" | wofi --dmenu --prompt "Omarchy Control Menu" --width 300 --height 400)
        
        case "$CHOICE" in
          "󰄀 Capture")
            CAPTURE_MENU="📷 Screenshot Region
🖼️  Screenshot Window  
📹 Record Region
🎥 Record Monitor
🎨 Color Picker
❌ Back"
            CAPTURE_CHOICE=$(echo "$CAPTURE_MENU" | wofi --dmenu --prompt "Capture Options")
            case "$CAPTURE_CHOICE" in
              "📷 Screenshot Region") hyprshot -m region ;;
              "🖼️  Screenshot Window") hyprshot -m window ;;
              "📹 Record Region") hyprshot -m region --freeze ;;
              "🎥 Record Monitor") hyprshot -m output ;;
              "🎨 Color Picker") hyprpicker -a ;;
            esac
            ;;
          "🎨 Style")
            STYLE_MENU="🎨 Theme Manager
🖼️  Change Wallpaper
🔄 Next Background
🌡️  Night Light Toggle
❌ Back"
            STYLE_CHOICE=$(echo "$STYLE_MENU" | wofi --dmenu --prompt "Style Options")
            case "$STYLE_CHOICE" in
              "🎨 Theme Manager") theme-menu ;;
              "🖼️  Change Wallpaper") ~/.config/hypr/hyprpaper.sh ;;
              "🔄 Next Background") theme-bg-next && notify-send "Background" "Switched to next wallpaper" ;;
              "🌡️  Night Light Toggle") 
                if pgrep -x "gammastep" > /dev/null; then
                  pkill gammastep && notify-send "Night Light" "Disabled"
                else
                  gammastep & notify-send "Night Light" "Enabled"
                fi
                ;;
            esac
            ;;
          "📦 Install")
            INSTALL_MENU="🔄 Update System
📦 Search Packages
🗑️  Garbage Collect
❌ Back"
            INSTALL_CHOICE=$(echo "$INSTALL_MENU" | wofi --dmenu --prompt "Package Management")
            case "$INSTALL_CHOICE" in
              "🔄 Update System") kitty -e bash -c "nix flake update && sudo nixos-rebuild switch --flake .; read -p 'Press enter to continue...'" ;;
              "📦 Search Packages") kitty -e bash -c "nix search nixpkgs" ;;
              "🗑️  Garbage Collect") kitty -e bash -c "sudo nix-collect-garbage -d; read -p 'Press enter to continue...'" ;;
            esac
            ;;
          "⚙️  System")
            SYSTEM_MENU="🔒 Lock Screen
😴 Suspend
🔄 Restart
🛑 Shutdown
🔄 Restart Hyprland
🔄 Restart Waybar
❌ Back"
            SYSTEM_CHOICE=$(echo "$SYSTEM_MENU" | wofi --dmenu --prompt "System Options")
            case "$SYSTEM_CHOICE" in
              "🔒 Lock Screen") ~/.config/hypr/hyprlock.sh ;;
              "😴 Suspend") systemctl suspend ;;
              "🔄 Restart") systemctl reboot ;;
              "🛑 Shutdown") systemctl poweroff ;;
              "🔄 Restart Hyprland") hyprctl dispatch exit ;;
              "🔄 Restart Waybar") pkill waybar && waybar & ;;
            esac
            ;;
          "📋 Keybindings")
            kitty -e bash -c "cat ~/.config/hypr/keybind.sh 2>/dev/null || echo 'Keybindings file not found'; read -p 'Press enter to continue...'" 
            ;;
          "🖥️  Monitors")
            MONITOR_MENU="📊 Display Info
🔧 Configure Displays
❌ Back"
            MONITOR_CHOICE=$(echo "$MONITOR_MENU" | wofi --dmenu --prompt "Monitor Options")
            case "$MONITOR_CHOICE" in
              "📊 Display Info") kitty -e bash -c "hyprctl monitors; read -p 'Press enter to continue...'" ;;
              "🔧 Configure Displays") notify-send "Monitor configuration" "Edit your Hyprland config to change monitor settings" ;;
            esac
            ;;
          "🔊 Audio")
            AUDIO_MENU="🎚️  Volume Control
🎧 Audio Devices
🔇 Toggle Mute
❌ Back"
            AUDIO_CHOICE=$(echo "$AUDIO_MENU" | wofi --dmenu --prompt "Audio Options")
            case "$AUDIO_CHOICE" in
              "🎚️  Volume Control") pavucontrol ;;
              "🎧 Audio Devices") pavucontrol ;;
              "🔇 Toggle Mute") wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
            esac
            ;;
          "📁 Files")
            yazi || kitty -e yazi
            ;;
          "🌐 Web Apps")
            ~/.local/bin/omarchy-webapp-launcher
            ;;
        esac
      '';
      executable = true;
    };
    
    # Enhanced Webapp Launcher Script
    ".local/bin/omarchy-webapp-launcher" = {
      text = ''
        #!/usr/bin/env bash
        # Enhanced Webapp Launcher with Management - SUPER + ALT + SPACE -> Web Apps
        
        WEBAPP_DIR="$HOME/.local/share/applications"
        
        # Function to get installed webapps
        get_webapps() {
          local webapps=()
          for file in "$WEBAPP_DIR"/*.desktop; do
            if [ -f "$file" ] && grep -q '^Exec=.*webapp-launch.*' "$file" 2>/dev/null; then
              local name=$(grep "^Name=" "$file" 2>/dev/null | cut -d= -f2-)
              if [[ -n "$name" ]]; then
                webapps+=("🌐 $name")
              fi
            fi
          done
          printf '%s\n' "''${webapps[@]}"
        }
        
        # Build the main menu
        INSTALLED_WEBAPPS=$(get_webapps)
        
        if [[ -n "$INSTALLED_WEBAPPS" ]]; then
          # Show installed webapps + management options
          MENU_OPTIONS="$INSTALLED_WEBAPPS
➕ Install New WebApp
📋 List All WebApps  
🗑️  Remove WebApp
❌ Cancel"
        else
          # No webapps installed, show install option and some quick options
          MENU_OPTIONS="➕ Install New WebApp
📋 List All WebApps
🚀 Quick Install Popular Apps
❌ Cancel"
        fi
        
        CHOICE=$(echo -e "$MENU_OPTIONS" | wofi --dmenu --prompt "Web Applications" --width 400 --height 500)
        
        case "$CHOICE" in
          "➕ Install New WebApp")
            # Launch interactive webapp installer
            kitty -e webapp-install
            ;;
          "📋 List All WebApps")
            # Show list of installed webapps
            kitty -e bash -c "webapp-list; read -p 'Press enter to continue...'"
            ;;
          "🗑️  Remove WebApp")
            # Launch interactive webapp remover
            kitty -e webapp-remove
            ;;
          "🚀 Quick Install Popular Apps")
            # Quick install menu for popular apps
            QUICK_MENU="🤖 ChatGPT
📧 Gmail
📅 Google Calendar
🎵 Spotify Web
💬 Slack
📋 Notion
🎨 Figma
💻 Linear
✅ Todoist
❌ Back"
            QUICK_CHOICE=$(echo -e "$QUICK_MENU" | wofi --dmenu --prompt "Quick Install")
            case "$QUICK_CHOICE" in
              "🤖 ChatGPT") 
                webapp-install "ChatGPT" "https://chatgpt.com/" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/openai-chatgpt.png"
                notify-send "WebApp Installed" "ChatGPT has been added to your applications"
                ;;
              "📧 Gmail")
                webapp-install "Gmail" "https://gmail.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/gmail.png"
                notify-send "WebApp Installed" "Gmail has been added to your applications"
                ;;
              "📅 Google Calendar")
                webapp-install "Google Calendar" "https://calendar.google.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-calendar.png"
                notify-send "WebApp Installed" "Google Calendar has been added to your applications"
                ;;
              "🎵 Spotify Web")
                webapp-install "Spotify" "https://open.spotify.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/spotify.png"
                notify-send "WebApp Installed" "Spotify has been added to your applications"
                ;;
              "💬 Slack")
                webapp-install "Slack" "https://app.slack.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/slack.png"
                notify-send "WebApp Installed" "Slack has been added to your applications"
                ;;
              "📋 Notion")
                webapp-install "Notion" "https://notion.so" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/notion.png"
                notify-send "WebApp Installed" "Notion has been added to your applications"
                ;;
              "🎨 Figma")
                webapp-install "Figma" "https://figma.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/figma.png"
                notify-send "WebApp Installed" "Figma has been added to your applications"
                ;;
              "💻 Linear")
                webapp-install "Linear" "https://linear.app" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/linear.png"
                notify-send "WebApp Installed" "Linear has been added to your applications"
                ;;
              "✅ Todoist")
                webapp-install "Todoist" "https://todoist.com/app" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/todoist.png"
                notify-send "WebApp Installed" "Todoist has been added to your applications"
                ;;
            esac
            ;;
          "❌ Cancel")
            exit 0
            ;;
          *)
            # Launch selected webapp
            if [[ "$CHOICE" =~ ^🌐\ (.*)$ ]]; then
              WEBAPP_NAME="''${BASH_REMATCH[1]}"
              # Find and launch the webapp
              for file in "$WEBAPP_DIR"/*.desktop; do
                if [ -f "$file" ] && grep -q '^Exec=.*webapp-launch.*' "$file" 2>/dev/null; then
                  local name=$(grep "^Name=" "$file" 2>/dev/null | cut -d= -f2-)
                  if [[ "$name" == "$WEBAPP_NAME" ]]; then
                    gtk-launch "$(basename "$file" .desktop)"
                    break
                  fi
                fi
              done
            fi
            ;;
        esac
      '';
      executable = true;
    };
  };
  
  # Add required packages for control menu
  home.packages = with pkgs; [
    hyprshot         # Screenshot tool
    hyprpicker       # Color picker  
    gammastep        # Night light
    pavucontrol      # Audio control
  ];
  
  # Add the keybinding for omarchy control menu
  wayland.windowManager.hyprland.settings.bind = [
    "$mainMod ALT, Space, exec, ~/.local/bin/omarchy-control-menu"
  ];
}
