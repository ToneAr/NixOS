# Sync all theme systems (Fish, Oh My Posh) with system accent
function system_theme_sync -d "Synchronize Fish and Oh My Posh themes with system accent"
    set -l accent (get_system_accent_color)

    # Update Fish theme
    fish_theme_from_system_accent

    # Update Oh My Posh environment variables
    update_environment_colors

    # Reinitialize Oh My Posh with new colors
    # Note: This requires a prompt redraw, which happens automatically
    if test "$argv[1]" = "--verbose"
        set_color green
        echo "System theme synchronized"
        set_color normal
        echo ""
        echo "  System Accent: "(set_color $accent)"████"(set_color normal)" $accent"
        echo ""
        echo "  Updated:"
        echo "    • Fish shell colors"
        echo "    • Oh My Posh environment variables"
        echo "    • ACCENT_COLOR = $ACCENT_COLOR"
        echo "    • ACCENT_DIM = $ACCENT_DIM"
        echo ""
    end
end
