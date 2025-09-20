#!/bin/bash

# Signal Desktop Catppuccin Mocha Theme Installer
# This script applies the Catppuccin Mocha theme to Signal Desktop

set -e

echo "Signal Desktop Catppuccin Mocha Theme Installer"
echo "=============================================="

# Set required variables
FLAVOR="mocha"
TEMP=$(mktemp -d)
SIGNAL_DIR="/usr/lib/signal-desktop/resources"

# Check for Flatpak Signal installation
if [ -d "/var/lib/flatpak/app/org.signal.Signal/current/active/files/Signal/resources" ]; then
    SIGNAL_DIR="/var/lib/flatpak/app/org.signal.Signal/current/active/files/Signal/resources"
    echo "Detected Flatpak Signal installation"
elif [ -d "/usr/lib/signal-desktop/resources" ]; then
    SIGNAL_DIR="/usr/lib/signal-desktop/resources"
    echo "Detected system Signal installation"
else
    echo "Error: Signal Desktop not found!"
    echo "Please install Signal Desktop first"
    exit 1
fi

echo "Using Signal directory: $SIGNAL_DIR"

# Check if asar is installed
if ! command -v asar &> /dev/null; then
    echo "Error: asar is not installed"
    echo "Installing asar via npm..."
    if command -v npm &> /dev/null; then
        sudo npm install -g @electron/asar
    else
        echo "Error: npm is not installed. Please install npm first."
        exit 1
    fi
fi

echo "Applying Catppuccin Mocha theme to Signal Desktop..."

# Extract asar into the temporary directory
echo "Extracting Signal app.asar..."
asar e "${SIGNAL_DIR}/app.asar" "${TEMP}"

# Download the theme file from the repository
echo "Downloading Catppuccin theme..."
curl -s "https://raw.githubusercontent.com/CalfMoon/signal-desktop/refs/heads/main/themes/catppuccin-${FLAVOR}.css" -o "${TEMP}/stylesheets/catppuccin-${FLAVOR}.css"

if [ ! -f "${TEMP}/stylesheets/catppuccin-${FLAVOR}.css" ]; then
    echo "Error: Failed to download theme file"
    rm -rf "${TEMP}"
    exit 1
fi

# Add import for the Catppuccin theme to the start of manifest.css
echo "Adding theme import to manifest.css..."
sed -i "1i @import \"catppuccin-${FLAVOR}.css\";" "${TEMP}/stylesheets/manifest.css"

# Pack the new theme into app.asar
echo "Repacking Signal app.asar..."
sudo asar p "${TEMP}" "${SIGNAL_DIR}/app.asar"

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${TEMP}"

echo ""
echo "✅ Catppuccin Mocha theme applied successfully!"
echo "🔄 Please restart Signal Desktop to see the changes."
echo ""
