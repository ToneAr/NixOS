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
    set -l status_color "#e88888"                           # Error status
    set -l cancel "#e88888"                                  # ^C indicator (error-like)
    set -l search_match "--background="(adjust_lightness $accent -0.1)  # Search match
    
    # Pager colors
    set -l pager_progress (adjust_lightness $accent 0.1)" --bold"  # Progress
    set -l pager_bg "--background=transparent"               # Background
    set -l pager_prefix (adjust_lightness $accent 0.05)" --bold"  # Prefix
    set -l pager_completion "#d5d5da"                        # Completion
    set -l pager_description "#8a8a94"                       # Description
    set -l pager_sel_bg "--background=#2d2d3d"               # Selected bg
    set -l pager_sel_prefix (adjust_lightness $accent 0.1)" --bold"  # Selected prefix
    set -l pager_sel_completion "#e8e8ec --bold"             # Selected completion
    set -l pager_sel_description (adjust_lightness $accent 0.05)  # Selected description
    set -l pager_sec_bg "--background=transparent"           # Secondary bg
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
