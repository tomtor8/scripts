#!/bin/bash

## HOW TO USE IT IN HYPRLAND CONFIG FILE
## set random wallpaper on startup
# exec-once=/path/to/set_random_wallpaper.sh
## set keybinding to change wallpaper manually
# bind=SUPER, W, exec,/path/to/set_random_wallpaper.sh
## change wallpaper every hour using cron table `crontab -e`
# 0 * * * * /path/to/set_random_wallpaper.sh

# Set your wallpaper directory
WALLPAPER_DIR="/home/tom/Pictures/wallpapers/watercolor/"

# Find all wallpaper files and select one randomly
wallpaper=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Get the list of monitors
monitors=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

# Preload the selected wallpaper
hyprctl hyprpaper preload "$wallpaper"

# Set the wallpaper for each monitor
for monitor in $monitors; do
  hyprctl hyprpaper wallpaper "$monitor,$wallpaper"
done
