#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Toggle airplane mode: soft-blocks/unblocks all radios (wifi, bluetooth, wwan) via rfkill.

if rfkill list | grep -q "Soft blocked: yes"; then
    rfkill unblock all
    notify-send "Airplane Mode" "Disabled" -a "AirplaneMode" -i network-wireless
else
    rfkill block all
    notify-send "Airplane Mode" "Enabled" -a "AirplaneMode" -i airplane-mode
fi
