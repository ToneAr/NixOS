# Made by Clause 4.5
# Demo the fish theme with various color examples
function fish_theme_demo -d "Demonstrate the fish theme colors"
    set -l accent (get_system_accent_color)

    echo ""
    set_color --bold
    echo "╔══════════════════════════════════════╗"
    echo "║      System Theme Demonstration      ║"
    echo "╚══════════════════════════════════════╝"
    set_color normal
    echo ""

    # Accent color display
    echo "  System Accent: "(set_color $accent)"███████"(set_color normal)" $accent"
    echo ""

    # Oh My Posh integration
    set_color --bold
    echo "Oh My Posh Integration:"
    set_color normal
    echo "  ACCENT_COLOR = "(set_color $ACCENT_COLOR)"███"(set_color normal)" $ACCENT_COLOR"
    echo "  ACCENT_DIM   = "(set_color $ACCENT_DIM)"███"(set_color normal)" $ACCENT_DIM"
    echo ""

    # Syntax highlighting examples
    set_color --bold
    echo "Syntax Highlighting:"
    set_color normal
    echo "  "(set_color $fish_color_command)"command"(set_color normal)" "(set_color $fish_color_param)"--parameter"(set_color normal)" "(set_color $fish_color_quote)"\"string\""(set_color normal)" "(set_color $fish_color_comment)"# comment"(set_color normal)
    echo ""

    # Command examples
    set_color --bold
    echo "Command Examples:"
    set_color normal
    echo "  "(set_color $fish_color_command)"ls"(set_color normal)" "(set_color $fish_color_param)"-la"(set_color normal)" "(set_color $fish_color_operator)"~"(set_color normal)"/"(set_color $fish_color_cwd)"config"(set_color normal)
    echo "  "(set_color $fish_color_command)"echo"(set_color normal)" "(set_color $fish_color_quote)"\"Hello, World!\""(set_color normal)
    echo "  "(set_color $fish_color_command)"git"(set_color normal)" "(set_color $fish_color_keyword)"commit"(set_color normal)" "(set_color $fish_color_param)"-m"(set_color normal)" "(set_color $fish_color_quote)"\"message\""(set_color normal)
    echo ""

    # State colors
    set_color --bold
    echo "State Colors:"
    set_color normal
	echo "  Success  "(set_color $fish_color_end)"Success"(set_color normal)
    echo "  Error:   "(set_color $fish_color_error)"Command not found"(set_color normal)
    echo "  Status:  "(set_color $fish_color_status)"✗ Failed"(set_color normal)
    echo "  Cancel:  "(set_color $fish_color_cancel)"^C"(set_color normal)
    echo ""

    # Path colors
    set_color --bold
    echo "Path Colors:"
    set_color normal
    echo "  User:    "(set_color $fish_color_user)"username"(set_color normal)
    echo "  Host:    "(set_color $fish_color_host)"hostname"(set_color normal)
    echo "  CWD:     "(set_color $fish_color_cwd)"~/.config/fish"(set_color normal)
    echo "  Root:    "(set_color $fish_color_cwd_root)"/root"(set_color normal)
    echo ""

    # Special characters
    set_color --bold
    echo "Special Characters:"
    set_color normal
    echo "  Operator:    "(set_color $fish_color_operator)"* ~ |"(set_color normal)
    echo "  Escape:      "(set_color $fish_color_escape)"\\n \\t"(set_color normal)
    echo "  Redirection: "(set_color $fish_color_redirection)"> >> <"(set_color normal)
    echo "  End:         "(set_color $fish_color_end)"; &"(set_color normal)
    echo ""

    # Autosuggestion
    set_color --bold
    echo "Autosuggestion:"
    set_color normal
    echo "  Type 'ls' → "(set_color $fish_color_command)"ls"(set_color normal)(set_color $fish_color_autosuggestion)" -la ~/.config"(set_color normal)
    echo ""

    # Color theory explanation
    set_color --bold
    echo "Color Relationships:"
    set_color normal
    echo "  • Commands & Keywords: Accent-based ("(adjust_lightness $accent 0.05)")"
    echo "  • Strings: Warm complement  ("(adjust_lightness (rotate_hue $accent 65) 0.08)")"
    echo "  • Operators: Cool complement ("(adjust_lightness (rotate_hue $accent -60) 0.05)")"
    echo "  • Types: Triadic variation   ("(adjust_lightness (rotate_hue $accent 35) 0.1)")"
    echo ""

    # Available commands
    set_color --bold
    echo "Available Commands:"
    set_color normal
    echo "  system_theme_sync   - Sync both Fish + Oh My Posh themes"
    echo "  fish_theme_info     - View detailed theme info"
    echo "  fish_theme_watch    - Enable auto-refresh (updates both)"
    echo "  omp_update_colors   - Update Oh My Posh colors only"
    echo "  fish_theme_demo     - Show this demonstration"
    echo ""
end
