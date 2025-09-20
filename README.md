# Robert's Catppuccin Mocha Dotfiles

A complete dotfiles configuration for a niri-based Wayland setup with Catppuccin Mocha theming.

**Important**: This dotfiles setup is designed for fresh Arch Linux installations with niri installed via `archinstall`. It assumes you have a base Arch system with niri already configured.

## Features

- **Window Manager**: niri (Wayland compositor)
- **Terminal**: Alacritty with Catppuccin Mocha theme
- **Shell**: Bash with ble.sh (blesh-git)
- **Status Bar**: Waybar
- **Launcher**: Fuzzel
- **Notifications**: Mako
- **Lock Screen**: swaylock-effects
- **System Monitor**: btop, htop
- **System Info**: fastfetch
- **Text Editor**: Geany with Catppuccin theme
- **Theme**: Catppuccin Mocha throughout
- **Additional Apps**: Signal, Steam, Zen Browser, Spotify with Spicetify

## Prerequisites

- Fresh Arch Linux installation
- niri window manager installed (via archinstall or manually)
- Internet connection
- User account with sudo privileges

## Installation

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the installation script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. The script will:
   - Install yay (AUR helper) if not present
   - Install all required packages from pacman and AUR
   - Copy configuration files to appropriate locations
   - Set up themes and apply configurations
   - Prompt for optional applications

## What's Included

### Core System
- niri window manager configuration
- Waybar status bar configuration
- Alacritty terminal configuration
- Bash configuration with ble.sh
- Fuzzel launcher configuration
- Mako notification configuration
- swaylock configuration
- wlogout configuration

### Theming
- Catppuccin Mocha GTK theme
- Catppuccin configurations for all supported applications
- Signal Desktop theming script

### Applications
- Geany text editor with Catppuccin theme
- Spotify with Spicetify and Catppuccin theme
- Steam (with version selection)
- Zen Browser
- Signal Desktop

## Package List

### Core Packages (pacman)
- niri
- waybar
- alacritty
- fuzzel
- mako
- wlogout
- btop
- htop
- fastfetch
- geany
- git
- base-devel

### AUR Packages
- blesh-git
- catppuccin-gtk-theme-mocha
- swaylock-effects-git
- zen-browser-bin

### Optional Packages
- signal-desktop
- steam / steam-native-runtime
- spotify
- spicetify-cli

## Manual Steps

Some configurations may require manual setup after installation:
- Spotify login for Spicetify theming
- Signal Desktop theme application (run `~/signal-theme.sh`)
- Steam configuration and library setup

## Post-Installation

After running the installation script:

1. **Restart your session** or reload configurations
2. **Signal theming**: If you installed Signal, run `~/signal-theme.sh` to apply Catppuccin theme
3. **Spotify theming**: If you installed Spotify:
   - Open Spotify and log in
   - Run: `spicetify backup apply`
   - Run: `spicetify config current_theme catppuccin-mocha`
   - Run: `spicetify apply`
4. **Verify configurations**: All applications should now use Catppuccin Mocha theme

## Structure

```
~/.dotfiles/
├── install.sh              # Main installation script
├── configs/                 # Configuration files
│   ├── .bashrc
│   ├── .blerc
│   ├── .gtkrc-2.0
│   ├── alacritty/
│   ├── niri/
│   ├── waybar/
│   ├── fuzzel/
│   ├── mako/
│   ├── swaylock/
│   ├── wlogout/
│   ├── geany/
│   ├── btop/
│   ├── htop/
│   ├── gtk-2.0/
│   ├── gtk-3.0/
│   ├── gtk-4.0/
│   └── spicetify/
├── scripts/                 # Utility scripts
│   └── signal-theme.sh
└── README.md
```

## Troubleshooting

- If you encounter permission errors, ensure you're not running as root
- If packages fail to install, check your internet connection and pacman mirrors
- For AUR packages, ensure `base-devel` is installed
- If themes don't apply correctly, try logging out and back in

## Credits

- [Catppuccin](https://github.com/catppuccin/catppuccin) for the amazing color scheme
- [niri](https://github.com/YaLTeR/niri) for the excellent Wayland compositor
- [ble.sh](https://github.com/akinomyoga/ble.sh) for enhanced bash experience