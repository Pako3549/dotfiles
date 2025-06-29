#!/bin/bash

#-------------------------------------------------
#----- CLIPHIST ROFI IMG SCRIPT
#-------------------------------------------------

if wl-paste --list-types | grep -q '^image/'; then
    TMP_FIX="/tmp/cliphist-img-auto-$$.png"
    wl-paste --type image/png > "$TMP_FIX"
    if file "$TMP_FIX" | grep -q "PNG image data"; then
        wl-copy < "$TMP_FIX"
    else
        rm -f "$TMP_FIX"
    fi
fi

tmp_dir="/tmp/cliphist"
rm -rf "$tmp_dir"
mkdir -p "$tmp_dir"

if [[ -n "$1" ]]; then
    cliphist decode <<<"$1" | wl-copy
    exit
fi

read -r -d '' prog <<'EOF'
/^[0-9]+\s<meta http-equiv=/ { next }
match($0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    path = "'$tmp_dir'/" grp[1] "." grp[3]
    system("cliphist decode <<<" grp[1] " > " path)
    print $0 "\0icon\x1f" path
    next
}
1
EOF

selection=$(cliphist list | gawk "$prog" | rofi -dmenu -i -p "Clipboard")

if [[ -n "$selection" ]]; then
    cliphist decode <<<"$selection" | wl-copy
fi
