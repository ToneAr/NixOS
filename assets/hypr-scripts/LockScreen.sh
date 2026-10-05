#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Lock the screen with hyprlock, avoiding duplicate instances.

if pgrep -x hyprlock >/dev/null; then
    exit
fi

hyprlock
