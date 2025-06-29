#!/usr/bin/bash

#-------------------------------------------------
#----- SCREENSHOT
#-------------------------------------------------

dir="/home/pako/Immagini/screenshots/"
filename="screenshot_$(date +"%Y%m%d_%H%M%S").png"

grim -g "$(slurp)" "$dir""$filename"
wl-copy < "$dir"/"$filename"

notify=$(dunstify -a System -u "low" --action="default, open_image" "Screenshot copied and saved" -t 2500 -h string:x-dunst-stack-tag:color-picker)
	[ "$notify" = "default" ] && {
		nautilus "$dir"/"$filename"
		dunstify -a System -u normal "Opening screenshot..." -t 1500 -h string:x-dunst-stack-tag:color-picker
	}
