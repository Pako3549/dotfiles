#!/bin/bash

#-------------------------------------------------
#----- CLIPHIST
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

if [[ -n "$1" ]]; then
    cliphist decode <<<"$1" | wl-copy
    exit
fi

mkdir -p "$tmp_dir"

read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
    print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
    next
}
1
EOF
cliphist list | gawk "$prog"

