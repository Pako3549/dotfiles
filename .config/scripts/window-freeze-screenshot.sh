#!/bin/bash

dir="$HOME/Pictures/screenshots"
mkdir -p "$dir"

file="$dir/screenshot_$(date +"%Y%m%d_%H%M%S").png"

grimblast --freeze copysave area "$file"

if [ -f "$file" ]; then
    notify=$(dunstify -a System -u low \
        --action="default, open_image" \
        "Screenshot copied and saved" \
        -t 2500 \
        -h string:x-dunst-stack-tag:screenshot)

    if [ "$notify" = "default" ]; then
        nautilus --select "$file"
        dunstify -a System -u normal "Opening screenshot..." -t 1500 \
            -h string:x-dunst-stack-tag:screenshot
    fi
else
    echo "Screenshot failed or cancelled"
    exit 0
fi