# Fish Theme - Dynamically generated from system accent color
# Matches the Neovim system-accent theme

function fish_theme_from_system_accent -d "Apply fish theme based on system accent color"
    # Get system accent color
    set -l accent_color (get_system_accent_color)

    # Generate complementary colors based on accent
    set -l colors (generate_fish_palette $accent_color)

    # Apply fish colors
    set -g fish_color_normal $colors[1]                # Normal text
    set -g fish_color_command $colors[2]               # Commands (accent-based)
    set -g fish_color_keyword $colors[3]               # Keywords
    set -g fish_color_quote $colors[4]                 # Strings
    set -g fish_color_redirection $colors[5]           # Redirections
    set -g fish_color_end $colors[6]                   # ; and &
    set -g fish_color_error $colors[7]                 # Errors
    set -g fish_color_param $colors[8]                 # Parameters
    set -g fish_color_comment $colors[9]               # Comments
    set -g fish_color_selection $colors[10]            # Selection background
    set -g fish_color_operator $colors[11]             # Operators like * and ~
    set -g fish_color_escape $colors[12]               # Escape sequences
    set -g fish_color_autosuggestion $colors[13]       # Autosuggestions
    set -g fish_color_cwd $colors[14]                  # Current directory
    set -g fish_color_cwd_root $colors[15]             # Current directory as root
    set -g fish_color_user $colors[16]                 # Username
    set -g fish_color_host $colors[17]                 # Hostname
    set -g fish_color_host_remote $colors[18]          # Remote hostname
    set -g fish_color_status $colors[19]               # Last command status
    set -g fish_color_cancel $colors[20]               # ^C indicator
    set -g fish_color_search_match $colors[21]         # History search match
    set -g fish_color_valid_path $colors[21]           # Valid paths with underline

    # Pager colors
    set -g fish_pager_color_progress $colors[22]       # Progress bar
    set -g fish_pager_color_background $colors[23]     # Background
    set -g fish_pager_color_prefix $colors[24]         # Prefix string
    set -g fish_pager_color_completion $colors[25]     # Completion text
    set -g fish_pager_color_description $colors[26]    # Description text
    set -g fish_pager_color_selected_background $colors[27] # Selected background
    set -g fish_pager_color_selected_prefix $colors[28]     # Selected prefix
    set -g fish_pager_color_selected_completion $colors[29] # Selected completion
    set -g fish_pager_color_selected_description $colors[30] # Selected description
    set -g fish_pager_color_secondary_background $colors[31] # Alternate row color
    set -g fish_pager_color_secondary_prefix $colors[32]     # Alternate prefix
    set -g fish_pager_color_secondary_completion $colors[33] # Alternate completion
    set -g fish_pager_color_secondary_description $colors[34] # Alternate description
end

function get_system_accent_color -d "Get system accent color from various sources"
    # Try KDE Plasma accent color (most reliable)
    set -l kde_accent (kreadconfig6 --file kdeglobals --group General --key AccentColor 2>/dev/null)
    if test -n "$kde_accent"
        # KDE format: "r,g,b" - convert to hex
        set -l rgb (string split ',' $kde_accent)
        if test (count $rgb) -eq 3
            printf "#%02x%02x%02x\n" $rgb[1] $rgb[2] $rgb[3]
            return 0
        end
    end

    # Try GNOME/GTK accent color from settings
    set -l gnome_accent (gsettings get org.gnome.desktop.interface accent-color 2>/dev/null | string trim -c "'" | string trim)
    if test -n "$gnome_accent"
        # GNOME uses named colors
        switch $gnome_accent
            case blue
                echo "#3584e4"
                return 0
            case green
                echo "#33d17a"
                return 0
            case yellow
                echo "#f6d32d"
                return 0
            case orange
                echo "#ff7800"
                return 0
            case red
                echo "#e01b24"
                return 0
            case purple
                echo "#9141ac"
                return 0
            case brown
                echo "#986a44"
                return 0
            case slate
                echo "#99c1f1"
                return 0
        end
    end

    # Try GTK CSS files
    if test -f ~/.config/gtk-3.0/gtk.css
        set -l gtk_accent (grep -oP '@define-color accent_color \K#[0-9a-fA-F]{6}' ~/.config/gtk-3.0/gtk.css 2>/dev/null | head -1)
        if test -n "$gtk_accent"
            echo $gtk_accent
            return 0
        end
    end

    if test -f ~/.config/gtk-4.0/gtk.css
        set -l gtk4_accent (grep -oP '@define-color accent_bg_color \K#[0-9a-fA-F]{6}' ~/.config/gtk-4.0/gtk.css 2>/dev/null | head -1)
        if test -n "$gtk4_accent"
            echo $gtk4_accent
            return 0
        end
    end

    # Default fallback (a nice blue)
    echo "#5B9BD5"
end

function generate_fish_palette -d "Generate color palette from base accent" -a base_accent
    # Adjust accent slightly
    set -l accent (adjust_saturation $base_accent 0.05)
    set -l accent (adjust_lightness $accent 0.05)

    # Generate colors based on accent
    set -l fg "#e8e8ec"                                      # Normal text
    set -l command (adjust_lightness $accent 0.1)            # Commands (accent-based)
    set -l keyword (adjust_lightness $accent 0.05)           # Keywords
    set -l string (adjust_lightness (rotate_hue $accent 65) 0.08)  # Strings
    set -l redirection (adjust_lightness (rotate_hue $accent -60) 0.05)  # Redirections
    set -l end_color (adjust_lightness (rotate_hue $accent 35) 0.1)  # ; and &
    set -l error "#e88888"                                   # Errors
    set -l param "#d5d5da"                                   # Parameters
    set -l comment "#8a8a94"                                 # Comments
    set -l selection "--background=#2d2d3d"                  # Selection
    set -l operator (adjust_lightness (rotate_hue $accent -60) 0.05)  # Operators
    set -l escape (adjust_lightness $accent 0.15)            # Escape sequences
    set -l autosuggestion "#6a6a6a"                          # Autosuggestions
    set -l cwd (adjust_lightness $accent 0.1)                # Current directory
    set -l cwd_root "#e88888"                                # Root directory
    set -l user (adjust_lightness (rotate_hue $accent -35) 0.1)  # Username
    set -l host (adjust_lightness (rotate_hue $accent 30) 0.08)  # Hostname
    set -l host_remote (adjust_lightness (rotate_hue $accent 120) 0.1)  # Remote host
    set -l status_color "#e88888"                            # Error status
    set -l cancel "#e88888"                                  # ^C indicator (error-like)
    set -l search_match "--background="(adjust_lightness $accent -0.1)  # Search match

    # Pager colors
    set -l pager_progress (adjust_lightness $accent 0.1)" --bold"  # Progress
    set -l pager_bg "--background=transparent"                     # Background
    set -l pager_prefix (adjust_lightness $accent 0.05)" --bold"   # Prefix
    set -l pager_completion "#d5d5da"                        # Completion
    set -l pager_description "#8a8a94"                       # Description
    set -l pager_sel_bg "--background=#2d2d3d"               # Selected bg
    set -l pager_sel_prefix (adjust_lightness $accent 0.1)" --bold"  # Selected prefix
    set -l pager_sel_completion "#e8e8ec --bold"             # Selected completion
    set -l pager_sel_description (adjust_lightness $accent 0.05)  # Selected description
    set -l pager_sec_bg "--background=transparent"                # Secondary bg
    set -l pager_sec_prefix (adjust_lightness $accent 0.05)  # Secondary prefix
    set -l pager_sec_completion "#b5b5bb"                    # Secondary completion
    set -l pager_sec_description "#6a6a6a"                   # Secondary description

    # Return all colors as list
    echo $fg
    echo $command
    echo $keyword
    echo $string
    echo $redirection
    echo $end_color
    echo $error
    echo $param
    echo $comment
    echo $selection
    echo $operator
    echo $escape
    echo $autosuggestion
    echo $cwd
    echo $cwd_root
    echo $user
    echo $host
    echo $host_remote
    echo $status_color
    echo $cancel
    echo $search_match
    echo $pager_progress
    echo $pager_bg
    echo $pager_prefix
    echo $pager_completion
    echo $pager_description
    echo $pager_sel_bg
    echo $pager_sel_prefix
    echo $pager_sel_completion
    echo $pager_sel_description
    echo $pager_sec_bg
    echo $pager_sec_prefix
    echo $pager_sec_completion
    echo $pager_sec_description
end
