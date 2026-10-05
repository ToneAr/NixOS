#!/usr/bin/env bash
set -euo pipefail

read_kde_accent() {
    if command -v kreadconfig6 >/dev/null 2>&1; then
        kreadconfig6 --file kdeglobals --group General --key AccentColor 2>/dev/null && return 0
    fi

    if command -v kreadconfig5 >/dev/null 2>&1; then
        kreadconfig5 --file kdeglobals --group General --key AccentColor 2>/dev/null && return 0
    fi

    awk -F= '
        $0 == "[General]" { in_general = 1; next }
        /^\[/ { in_general = 0 }
        in_general && $1 == "AccentColor" { print $2; exit }
    ' "$HOME/.config/kdeglobals"
}

accent_rgb="$(read_kde_accent | tr -d '[:space:]')"
IFS=, read -r red green blue extra <<< "$accent_rgb"

if [[ -z "${red:-}" || -z "${green:-}" || -z "${blue:-}" || -n "${extra:-}" ]]; then
    echo "Could not read KDE AccentColor from kdeglobals" >&2
    exit 1
fi

accent_hex="$(printf '%02X%02X%02X' "$red" "$green" "$blue")"
accent_css="#$accent_hex"
wallust_accent_css="$(awk '/@define-color color7 / { print $3; exit }' "$HOME/.config/waybar/wallust/colors-waybar.css" 2>/dev/null | tr -d ';')"

if [[ ! "$wallust_accent_css" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    wallust_accent_css="#[0-9A-Fa-f]{6}"
fi

replace_in_file() {
    local file="$1"
    shift

    [[ -f "$file" ]] || return 0
    perl -0pi "$@" "$file"
}

replace_in_file "$HOME/.cache/wallust/hyprland.conf" \
    -e 's/\$plasma_accent_color = rgb\([0-9A-Fa-f]{6}\)/\$plasma_accent_color = rgb('"$accent_hex"')/;' \
    -e 's#\$active_border_color = rgb\([0-9A-Fa-f]{6}\) rgb\([0-9A-Fa-f]{6}\) 45deg#\$active_border_color = rgb('"$accent_hex"') rgb('"$accent_hex"') 45deg#;'

replace_in_file "$HOME/.config/waybar/wallust/colors-waybar.css" \
    -e 's/@define-color color7 #[0-9A-Fa-f]{6};/@define-color color7 '"$accent_css"';/;'

replace_in_file "$HOME/.config/rofi/wallust/colors-rofi.rasi" \
    -e 's/(active-background|urgent-background|alternate-active-background|selected-active-background|selected-normal-background|selected-urgent-background|border-color): '"$wallust_accent_css"';/$1: '"$accent_css"';/g;'

replace_in_file "$HOME/.config/wofi/style.css" \
    -e 's/'"$wallust_accent_css"'/'"$accent_css"'/g;'

export WOLFIE_PLASMA_ACCENT="$accent_css"
python3 - <<'WOLFIEPY'
import json
import os
from pathlib import Path

path = Path.home() / ".config/wolfie/themes/wallust-plasma.json"
accent = os.environ.get("WOLFIE_PLASMA_ACCENT", "").strip()

if path.exists() and accent.startswith("#") and len(accent) == 7:
    with path.open() as file:
        theme = json.load(file)

    styles = theme.setdefault("styles", {})
    for key in (
        "builtin_symbol",
        "completion_command",
        "menu_match",
        "prompt_left",
    ):
        style = styles.setdefault(key, {})
        if isinstance(style, dict):
            style["fg"] = accent

    styles["completion_symbol"] = accent

    for key in ("menu_selected_text", "menu_selected_match", "visual_selection"):
        style = styles.setdefault(key, {})
        if isinstance(style, dict):
            style["bg"] = accent

    with path.open("w") as file:
        json.dump(theme, file, indent=2)
        file.write("\n")
WOLFIEPY

if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
fi
