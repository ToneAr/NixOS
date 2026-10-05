## Made by Claude 4.5

function adjust_lightness -d "Adjust lightness of hex color" -a hex -a amount
    # Strip leading '#'
    set -l h_str (string replace -r '^#' '' -- $hex)

    # Extract and convert RGB hex to decimal [0-255]
    set -l r (math "0x"(string sub -s 1 -l 2 $h_str))
    set -l g (math "0x"(string sub -s 3 -l 2 $h_str))
    set -l b (math "0x"(string sub -s 5 -l 2 $h_str))

    # Normalize to [0-1]
    set r (math "$r / 255")
    set g (math "$g / 255")
    set b (math "$b / 255")

    # RGB to HSL
    set -l max_c (math "max($r, $g, $b)")
    set -l min_c (math "min($r, $g, $b)")
    set -l delta (math "$max_c - $min_c")

    # Calculate Lightness
    set -l l (math "($max_c + $min_c) / 2")

    # Calculate Saturation
    set -l s 0
    if test (math "$delta") != 0
        if test (math "$l") -lt 0.5
            set s (math "$delta / ($max_c + $min_c)")
        else
            set s (math "$delta / (2 - $max_c - $min_c)")
        end
    end

    # Calculate Hue
    set -l h 0
    if test (math "$delta") != 0
        # Use scaled integers for comparison to avoid floating point issues
        set -l scale 1000000
        set -l max_scaled (math "floor($max_c * $scale)")
        set -l r_scaled (math "floor($r * $scale)")
        set -l g_scaled (math "floor($g * $scale)")
		# set -l b_scaled (math "floor($b * $scale)")

        if test $max_scaled -eq $r_scaled
            set h (math "((($g - $b) / $delta) % 6) / 6")
        else if test $max_scaled -eq $g_scaled
            set h (math "((($b - $r) / $delta) + 2) / 6")
        else
            set h (math "((($r - $g) / $delta) + 4) / 6")
        end

        # Ensure hue is positive
        if test (math "$h") -lt 0
            set h (math "$h + 1")
        end
    end

    # Adjust lightness and clamp to [0, 1]
    set l (math "max(0, min(1, $l + $amount))")

    # HSL to RGB
    if test (math "$s") = 0
        # Achromatic (gray)
        set r $l
        set g $l
        set b $l
    else
        # Helper values
        set -l q
        if test (math "$l") -lt 0.5
            set q (math "$l * (1 + $s)")
        else
            set q (math "$l + $s - $l * $s")
        end
        set -l p (math "2 * $l - $q")

        # Convert hue to RGB using helper function logic
        set -l h_r (math "$h + 1/3")
        set -l h_g $h
        set -l h_b (math "$h - 1/3")

        # Normalize hue values to [0, 1]
        if test (math "$h_r") -lt 0
            set h_r (math "$h_r + 1")
        end
        if test (math "$h_r") -gt 1
            set h_r (math "$h_r - 1")
        end
        if test (math "$h_g") -lt 0
            set h_g (math "$h_g + 1")
        end
        if test (math "$h_g") -gt 1
            set h_g (math "$h_g - 1")
        end
        if test (math "$h_b") -lt 0
            set h_b (math "$h_b + 1")
        end
        if test (math "$h_b") -gt 1
            set h_b (math "$h_b - 1")
        end

        # Convert each channel
        # Red
        if test (math "$h_r") -lt (math "1/6")
            set r (math "$p + ($q - $p) * 6 * $h_r")
        else if test (math "$h_r") -lt 0.5
            set r $q
        else if test (math "$h_r") -lt (math "2/3")
            set r (math "$p + ($q - $p) * (2/3 - $h_r) * 6")
        else
            set r $p
        end

        # Green
        if test (math "$h_g") -lt (math "1/6")
            set g (math "$p + ($q - $p) * 6 * $h_g")
        else if test (math "$h_g") -lt 0.5
            set g $q
        else if test (math "$h_g") -lt (math "2/3")
            set g (math "$p + ($q - $p) * (2/3 - $h_g) * 6")
        else
            set g $p
        end

        # Blue
        if test (math "$h_b") -lt (math "1/6")
            set b (math "$p + ($q - $p) * 6 * $h_b")
        else if test (math "$h_b") -lt 0.5
            set b $q
        else if test (math "$h_b") -lt (math "2/3")
            set b (math "$p + ($q - $p) * (2/3 - $h_b) * 6")
        else
            set b $p
        end
    end

    # Convert back to [0-255] and ensure valid range
    set -l r_i (math "max(0, min(255, round($r * 255)))")
    set -l g_i (math "max(0, min(255, round($g * 255)))")
    set -l b_i (math "max(0, min(255, round($b * 255)))")

    printf "#%02x%02x%02x\n" $r_i $g_i $b_i
end
