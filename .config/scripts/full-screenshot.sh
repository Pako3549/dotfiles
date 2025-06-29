#!/usr/bin/bash

dir="/home/pako/Immagini/screenshots/"

before_count=$(find "$dir" -maxdepth 1 -type f -name '*_hyprshot.png' 2>/dev/null | wc -l)

hyprshot -m output -o "$dir" --silent

after_count=$(find "$dir" -maxdepth 1 -type f -name '*_hyprshot.png' 2>/dev/null | wc -l)

if [ "$after_count" -gt "$before_count" ]; then
    new_file=$(find "$dir" -maxdepth 1 -type f -name '*_hyprshot.png' 2>/dev/null | sort | tail -n1)
    echo "Nuovo file: $new_file"
    
    wl-copy < "$new_file"
    
    notify=$(dunstify -a System -u "low" --action="default, open_image" "Screenshot copied and saved" -t 2500 -h string:x-dunst-stack-tag:color-picker)
    
    if [ "$notify" = "default" ]; then
        nautilus --select "$new_file"
        dunstify -a System -u normal "Opening screenshot..." -t 1500 -h string:x-dunst-stack-tag:color-picker
    fi
else
    echo "Screenshot cancellato o fallito"
    exit 0
fi
