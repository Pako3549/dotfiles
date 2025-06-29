#!/usr/bin/bash

#-------------------------------------------------
#----- WAYBAR RESTART
#-------------------------------------------------

CONFIG="$HOME/.config/waybar/config.jsonc"
STYLE="$HOME/.config/waybar/style.css"

if pgrep -x "waybar" >/dev/null; then
  echo "Waybar is running. Restarting..."
  pkill waybar
  sleep 1  
else
  echo "Waybar is not running. Starting..."
fi

waybar -c $CONFIG -s $STYLE >/dev/null 2>&1 &

sleep 1
if pgrep -x "waybar" >/dev/null; then
  echo "Waybar is now running."
else
  echo "Failed to start Waybar."
fi