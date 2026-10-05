#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Power menu (logout/lock/reboot/shutdown/suspend/hibernate). Toggles closed if already open.

if pgrep -x wlogout >/dev/null; then
    pkill -x wlogout
    exit
fi

wlogout
