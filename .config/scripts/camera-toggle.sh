#!/bin/bash
# Camera kill-switch for the Waybar module "custom/camera"
# Click -> hard-disables the webcam at kernel level, click again -> re-enables it.
# Works even while an application is actively using the camera:
#   1) tries to unload the uvcvideo kernel module (clean path, camera idle)
#   2) if the module is in use, deauthorizes the USB camera ("authorized=0"):
#      the device disappears immediately for every app, like yanking the cable,
#      without killing any application.
#
# Usage:
#   camera-toggle.sh           -> prints waybar status (JSON)
#   camera-toggle.sh --toggle  -> toggles the camera and refreshes waybar
#
# Requires the sudo rules installed by install.sh (setup_camera_toggle):
# passwordless modprobe uvcvideo + /usr/local/bin/camera-sysfs (root helper)

CAMERA_MODULE="uvcvideo"
WAYBAR_SIGNAL=8                              # custom/camera listens on SIGRTMIN+8
USB_STATE="$HOME/.cache/camera-usb-device"   # USB id (e.g. 3-9) while killed at USB level

ICON_ON=""    # camera
ICON_OFF=""   # camera blocked

# Truth from the system: the camera works only if its video nodes exist
camera_on() {
    compgen -G "/dev/video*" > /dev/null
}

camera_loaded() {
    grep -qw "^$CAMERA_MODULE" /proc/modules
}

# USB id of the webcam while its driver is bound (e.g. "3-9")
camera_usb_dev() {
    local iface dev
    for iface in /sys/bus/usb/drivers/uvcvideo/*:*; do
        [ -e "$iface" ] || continue
        dev="${iface##*/}"
        dev="${dev%%:*}"
        printf '%s\n' "$dev"
        return 0
    done
    return 1
}

# Ask waybar to re-run the module and update icon/state
refresh_waybar() {
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
}

print_status() {
    if camera_on; then
        printf '{"text": "%s", "class": "on", "tooltip": "Camera ON\\nClick to disable"}\n' "$ICON_ON"
    else
        printf '{"text": "%s", "class": "off", "tooltip": "Camera OFF\\nClick to enable"}\n' "$ICON_OFF"
    fi
}

disable_camera() {
    # 1) clean path: unload the whole driver
    if err=$(sudo -n modprobe -r "$CAMERA_MODULE" 2>&1); then
        notify-send -u low "Camera" "Webcam disabled" 2>/dev/null
        return 0
    fi
    # 2) driver in use: disconnect the USB camera itself
    if echo "$err" | grep -qiE "in use|busy"; then
        if dev=$(camera_usb_dev); then
            printf '%s\n' "$dev" > "$USB_STATE"
            if sudo -n /usr/local/bin/camera-sysfs off "$dev" 2>/dev/null; then
                notify-send -u low "Camera" "Webcam killed (was in use)" 2>/dev/null
                return 0
            fi
        fi
        notify-send -u critical "Camera" "Cannot disable webcam" 2>/dev/null
        return 1
    fi
    if echo "$err" | grep -qiE "password is required|not allowed"; then
        notify-send -u critical "Camera" "Missing sudo rule, run install.sh to enable the kill-switch" 2>/dev/null
    else
        notify-send -u critical "Camera" "Cannot disable webcam: $err" 2>/dev/null
    fi
    return 1
}

enable_camera() {
    # camera was killed at USB level -> re-authorize the device
    if [ -f "$USB_STATE" ]; then
        sudo -n /usr/local/bin/camera-sysfs on "$(cat "$USB_STATE")" 2>/dev/null
        rm -f "$USB_STATE"
    fi
    # make sure the driver is loaded (it binds automatically to the camera)
    if ! camera_loaded; then
        if err=$(sudo -n modprobe "$CAMERA_MODULE" 2>&1); then
            notify-send -u low "Camera" "Webcam enabled" 2>/dev/null
        else
            notify-send -u critical "Camera" "Cannot enable webcam: $err" 2>/dev/null
            return 1
        fi
    else
        notify-send -u low "Camera" "Webcam enabled" 2>/dev/null
    fi
}

toggle_camera() {
    if camera_on; then
        disable_camera
    else
        enable_camera
    fi
}

case "$1" in
    --toggle)
        toggle_camera
        refresh_waybar
        ;;
esac

print_status
