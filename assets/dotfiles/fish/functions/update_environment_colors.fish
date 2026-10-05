# Update Oh My Posh colors based on system accent
function update_environment_colors -d "Update Oh My Posh color environment variables"
    set -l accent (get_system_accent_color)
    set -l accent_dim (adjust_lightness $accent -0.3)
	set -l accent_font (get_font_color $accent)
	set -l accent_dim_font (get_font_color $accent_dim)

    set -gx ACCENT_COLOR $accent
    set -gx ACCENT_DIM $accent_dim
	set -gx ACCENT_FONT $accent_font
	set -gx ACCENT_DIM_FONT $accent_dim_font

    if test "$argv[1]" = "--verbose"
        echo "Oh My Posh colors updated:"
        echo "  ACCENT_COLOR: $accent"
        echo "  ACCENT_DIM: $accent_dim"
		echo "  ACCENT_FONT: $accent_font"
		echo "  ACCENT_DIM_FONT: $accent_dim_font"
    end
end
