#!/bin/bash
# Toggle Wi-Fi hotspot on wlo1
# If hotspot is running -> stop it
# If not -> start it

SSID="PakoPC"
PASSWORD="pakito07"
IFACE="wlo1"
CON_NAME="Hotspot"

# Check if hotspot is active
if nmcli -t -f NAME con show --active | grep -q "^$CON_NAME$"; then
    echo "[*] Stopping hotspot..."
    nmcli connection down "$CON_NAME" 2>/dev/null
    nmcli connection delete "$CON_NAME" 2>/dev/null
    notify-send "Hotspot stopped" "SSID $SSID"
    echo "[+] Hotspot stopped."
else
    echo "[*] Starting hotspot $SSID on $IFACE..."
    nmcli connection delete "$CON_NAME" 2>/dev/null
    nmcli connection add type wifi ifname "$IFACE" mode ap con-name "$CON_NAME" ssid "$SSID"
    nmcli connection modify "$CON_NAME" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$PASSWORD"
    nmcli connection modify "$CON_NAME" ipv4.method shared
    nmcli connection up "$CON_NAME"
    notify-send "Hotspot started" "SSID=$SSID Password=$PASSWORD"
    echo "[+] Hotspot started: SSID=$SSID, PASSWORD=$PASSWORD"
fi
