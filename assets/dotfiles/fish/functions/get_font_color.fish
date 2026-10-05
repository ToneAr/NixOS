function get_font_color -d "Get font color based on background lightness" -a hex
	set -l l (get_luminosity $hex)

	if test $l -lt 0.45
		echo "#cccccc"
	else
		echo "#222222"
	end
end
