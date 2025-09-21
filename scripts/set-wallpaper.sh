#!/bin/bash

# Wallpaper setter script for swaybg
# This script sets the desktop wallpaper using swaybg

WALLPAPER_PATH="$HOME/Pictures/Wallpapers/celeste.png"

# Kill any existing swaybg processes
pkill swaybg 2>/dev/null

# Set wallpaper if it exists
if [[ -f "$WALLPAPER_PATH" ]]; then
    swaybg -m fill -i "$WALLPAPER_PATH" &
    echo "Wallpaper set: $WALLPAPER_PATH"
else
    echo "Warning: Wallpaper not found at $WALLPAPER_PATH"
fi