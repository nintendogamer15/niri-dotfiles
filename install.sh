#!/bin/bash

# Robert's Catppuccin Mocha Dotfiles Installation Script
# Designed for fresh Arch Linux installations with niri (installed via archinstall)

set -e

# Store the script directory for later use
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root"
   exit 1
fi

log_info "Starting dotfiles installation for Catppuccin Mocha setup"

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    log_info "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"
    log_success "yay installed successfully"
else
    log_info "yay is already installed"
fi

# Update system
log_info "Updating system packages..."
sudo pacman -Syu --noconfirm

# Core packages from pacman
PACMAN_PACKAGES=(
    "niri"
    "waybar"
    "alacritty"
    "fuzzel"
    "mako"
    "btop"
    "htop"
    "fastfetch"
    "geany"
    "git"
    "base-devel"
    "npm"
    "swaybg"
    "iwd"
    "blueman"
    "pavucontrol"
    "playerctl"
    "mpd"
    "lightdm"
    "lightdm-gtk-greeter"
    "ttf-jetbrains-mono"
    "ttf-nerd-fonts-symbols"
    "ttf-nerd-fonts-symbols-common"
    "ttf-nerd-fonts-symbols-mono"
)

# AUR packages
AUR_PACKAGES=(
    "blesh-git"
    "catppuccin-gtk-theme-mocha"
    "iwgtk"
    "niriswitcher"
    "swaylock-effects-git"
    "wlogout"
    "zen-browser-bin"
)

# Install core pacman packages
log_info "Installing core packages from pacman..."
for package in "${PACMAN_PACKAGES[@]}"; do
    if pacman -Q "$package" &> /dev/null; then
        log_info "$package is already installed"
    else
        log_info "Installing $package..."
        sudo pacman -S --noconfirm "$package"
    fi
done

# Install AUR packages
log_info "Installing AUR packages..."

# Handle swaylock conflict first
if pacman -Q swaylock &> /dev/null; then
    log_info "Removing swaylock to avoid conflict with swaylock-effects-git..."
    sudo pacman -R --noconfirm swaylock
else
    log_info "swaylock not found, proceeding with AUR package installation"
fi

for package in "${AUR_PACKAGES[@]}"; do
    if yay -Q "$package" &> /dev/null; then
        log_info "$package is already installed"
    else
        log_info "Installing $package from AUR..."
        yay -S --noconfirm "$package"
    fi
done

# Optional applications
echo
log_info "Optional applications installation:"

# Signal Desktop
read -p "Install Signal Desktop? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing Signal Desktop..."
    sudo pacman -S --noconfirm signal-desktop
    log_success "Signal Desktop installed"
fi

# Steam
read -p "Install Steam? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Steam installation options:"
    echo "1) Let me install it manually (recommended for NVIDIA users)"
    echo "2) Install standard steam package"
    echo "3) Install steam-native-runtime"
    read -p "Choose (1-3): " -n 1 -r steam_choice
    echo
    case $steam_choice in
        1)
            log_info "Manual Steam installation selected"
            log_info "Please run: sudo pacman -S steam"
            log_info "This will show you all available options including NVIDIA-specific versions"
            log_warning "After installation, Steam configuration will be preserved in your dotfiles"
            ;;
        2)
            log_info "Installing standard Steam..."
            sudo pacman -S --noconfirm steam
            log_success "Steam installed"
            ;;
        3)
            log_info "Installing Steam with native runtime..."
            sudo pacman -S --noconfirm steam-native-runtime
            log_success "Steam installed"
            ;;
        *)
            log_info "Installing standard Steam..."
            sudo pacman -S --noconfirm steam
            log_success "Steam installed"
            ;;
    esac
fi

# Spotify with Spicetify
read -p "Install Spotify with Spicetify? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing Spotify and Spicetify..."
    yay -S --noconfirm spotify spicetify-cli
    log_success "Spotify and Spicetify installed"
    log_warning "You'll need to log into Spotify first, then run spicetify configuration manually"
fi

# Copy configuration files
log_info "Copying configuration files..."

# Create necessary directories
mkdir -p ~/.config

# Copy configs
cp configs/.bashrc ~/.bashrc
cp configs/.blerc ~/.blerc
cp configs/.gtkrc-2.0 ~/.gtkrc-2.0

# Copy .config directories
for config_dir in configs/*/; do
    if [[ -d "$config_dir" ]]; then
        dir_name=$(basename "$config_dir")
        if [[ "$dir_name" != "." && "$dir_name" != ".." ]]; then
            log_info "Copying $dir_name configuration..."
            cp -r "$config_dir" ~/.config/
        fi
    fi
done

# Copy scripts
log_info "Copying utility scripts..."
cp scripts/signal-theme.sh ~/signal-theme.sh
chmod +x ~/signal-theme.sh

# Copy wallpapers
log_info "Copying wallpapers..."
mkdir -p ~/Pictures/Wallpapers
cp wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null || log_warning "No wallpapers to copy"

# Set up GTK theme
log_info "Setting up GTK theme..."
gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-mauve-standard+default"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Set up ble.sh
log_info "Setting up ble.sh..."
if [[ ! -d ~/ble.sh ]]; then
    log_info "Cloning ble.sh repository..."
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git ~/ble.sh
    cd ~/ble.sh
    make install PREFIX=~/.local
    cd "$SCRIPT_DIR"
fi

log_success "ble.sh setup complete"

# Set up oh-my-bash
log_info "Setting up oh-my-bash..."
if [[ ! -d ~/.oh-my-bash ]]; then
    log_info "Installing oh-my-bash..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
    log_success "oh-my-bash installed"
else
    log_info "oh-my-bash is already installed"
fi

# Install asar for Signal theming
log_info "Installing asar for Signal Desktop theming..."
sudo npm install -g @electron/asar

# Enable and configure iwd service for iwgtk
log_info "Configuring iwd service for iwgtk..."
sudo systemctl enable iwd
sudo systemctl start iwd

# Create iwd configuration directory and basic config
sudo mkdir -p /etc/iwd
sudo tee /etc/iwd/main.conf > /dev/null <<EOF
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF

log_success "iwd service configured and enabled"

# Set up wallpaper with swaybg
log_info "Setting up wallpaper..."
if [[ -f ~/Pictures/Wallpapers/celeste.png ]]; then
    # Add wallpaper to niri startup
    if [[ -f ~/.config/niri/config.kdl ]]; then
        # Add wallpaper spawn command to niri config if not already present
        if ! grep -q "swaybg" ~/.config/niri/config.kdl; then
            sed -i '/spawn-at-startup "waybar"/a spawn-at-startup "swaybg -m fill -i ~/Pictures/Wallpapers/celeste.png"' ~/.config/niri/config.kdl
        fi
    fi
    log_success "Wallpaper setup complete"
else
    log_warning "Wallpaper file not found, skipping wallpaper setup"
fi

# Set up LightDM configuration
log_info "Configuring LightDM login manager..."
if [[ -f configs/lightdm/lightdm-gtk-greeter.conf ]]; then
    sudo cp configs/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/
    # Copy wallpapers to system location
    sudo mkdir -p /usr/share/lightdm
    sudo cp wallpapers/firewatch.jpg /usr/share/lightdm/
    sudo cp wallpapers/042a5f1cab2d1ccf90e879dc5592576a.jpg /usr/share/lightdm/
    # Enable lightdm service
    sudo systemctl enable lightdm
    log_success "LightDM configured and enabled"
    else
        log_warning "LightDM config not found, skipping LightDM setup"
    fi
    
    # Set up Zen Browser theming
    log_info "Setting up Zen Browser Catppuccin theme..."
    if command -v zen-browser &> /dev/null; then
        ZEN_PROFILE_DIR=$(find ~/.zen -name "*.Default*" -type d | head -1)
        if [[ -n "$ZEN_PROFILE_DIR" ]]; then
            # Copy chrome folder with theme files
            cp -r configs/zen-browser/chrome "$ZEN_PROFILE_DIR/"
            
            # Enable legacy user profile customizations in prefs.js
            PREFS_FILE="$ZEN_PROFILE_DIR/prefs.js"
            if [[ -f "$PREFS_FILE" ]]; then
                # Remove existing setting if present
                sed -i '/toolkit.legacyUserProfileCustomizations.stylesheets/d' "$PREFS_FILE"
            fi
            # Add the setting
            echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$PREFS_FILE"
            
            log_success "Zen Browser Catppuccin theme configured"
            log_info "Note: Restart Zen Browser to see theme changes"
        else
            log_warning "Zen Browser profile directory not found"
        fi
    else
        log_info "Zen Browser not installed, skipping theme setup"
    fi

# Spicetify theme setup (if installed)
if command -v spicetify &> /dev/null; then
    log_info "Setting up Spicetify Catppuccin theme..."
    if [[ -d ~/.config/spicetify ]]; then
        log_warning "Spicetify is installed but you need to:"
        log_warning "1. Open Spotify and log in"
        log_warning "2. Run: spicetify backup apply"
        log_warning "3. Run: spicetify config current_theme catppuccin-mocha"
        log_warning "4. Run: spicetify apply"
    fi
fi

# Final instructions
echo
log_success "Dotfiles installation complete!"
echo
log_info "Next steps:"
log_info "1. Restart your session or reload configurations"
log_info "2. If you installed Signal, run ~/signal-theme.sh to apply Catppuccin theme"
log_info "3. If you installed Spotify, follow the Spicetify setup instructions above"
log_info "4. All configurations should now be applied with Catppuccin Mocha theme"

echo
log_info "Enjoy your riced niri setup! 🎨"