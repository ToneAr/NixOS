function get_luminosity -d "Get color luminosity based on human perception" -a hex
	 # strip leading '#'
	set -l hhex (string replace -r '^#' '' -- $hex)
	set -l r_hex (string sub -s 1 -l 2 $hhex)
	set -l g_hex (string sub -s 3 -l 2 $hhex)
	set -l b_hex (string sub -s 5 -l 2 $hhex)

	# hex -> 0..1 RGB
	set -l r_dec (printf '%d' 0x$r_hex)
	set -l g_dec (printf '%d' 0x$g_hex)
	set -l b_dec (printf '%d' 0x$b_hex)
	set -l r (math "$r_dec / 255")
	set -l g (math "$g_dec / 255")
	set -l b (math "$b_dec / 255")

	# calculate luminosity
	echo (math "($r * 0.229) + ($g * 0.587) + ($b * 0.114)")
end
