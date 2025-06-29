#!/usr/bin/bash

#-------------------------------------------------
#----- FULL SCREENSHOT 
#-------------------------------------------------

dir="/home/pako/Immagini/screenshots/"

hyprshot -m output -o "$dir" --silent

latest_file=$(ls -t "$dir"*_hyprshot.png 2>/dev/null | head -n1)

wl-copy < "$latest_file"

notify=$(dunstify -a System -u "low" --action="default, open_image" "Screenshot copied and saved" -t 2500 -h string:x-dunst-stack-tag:color-picker)
	[ "$notify" = "default" ] && {
		nautilus "file://$latest_file"
		dunstify -a System -u normal "Opening screenshot..." -t 1500 -h string:x-dunst-stack-tag:color-picker
	}

