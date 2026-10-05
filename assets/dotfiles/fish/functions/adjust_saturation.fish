## Made by Claude 4.5
function adjust_saturation -d "Adjust saturation of hex color" -a hex -a amount
    # Parse hex (allow leading #)
    set -l h (string replace -r '^#' '' -- $hex)
    set -l rr (string sub -s 1 -l 2 -- $h)
    set -l gg (string sub -s 3 -l 2 -- $h)
    set -l bb (string sub -s 5 -l 2 -- $h)

    # Convert to 0..1 floats
    set -l r_int (printf "%d" 0x$rr)
    set -l g_int (printf "%d" 0x$gg)
    set -l b_int (printf "%d" 0x$bb)
    set -l r (math "$r_int / 255")
    set -l g (math "$g_int / 255")
    set -l b (math "$b_int / 255")

    # Use scaled integers for comparisons
    set -l scale 1000000
    set -l r_s (math "floor($r * $scale)")
    set -l g_s (math "floor($g * $scale)")
    set -l b_s (math "floor($b * $scale)")

    # Find max and min
    set -l maxc $r
    set -l maxc_s $r_s
    if test $g_s -gt $maxc_s
        set maxc $g
        set maxc_s $g_s
    end
    if test $b_s -gt $maxc_s
        set maxc $b
        set maxc_s $b_s
    end

    set -l minc $r
    set -l minc_s $r_s
    if test $g_s -lt $minc_s
        set minc $g
        set minc_s $g_s
    end
    if test $b_s -lt $minc_s
        set minc $b
        set minc_s $b_s
    end

    # Lightness
    set -l l (math "($maxc + $minc) / 2")

    # Saturation and hue
    set -l s 0
    set -l hval 0
    if test $maxc_s -ne $minc_s
        set -l d (math "$maxc - $minc")
        set -l l_s (math "floor($l * $scale)")
        set -l half_s (math "floor(0.5 * $scale)")
        if test $l_s -gt $half_s
            set s (math "$d / (2 - $maxc - $minc)")
        else
            set s (math "$d / ($maxc + $minc)")
        end

        if test $r_s -eq $maxc_s
            set -l tmp (math "($g - $b) / $d")
            set -l tmp_s (math "floor($tmp * $scale)")
            set -l zero_s 0
            if test $tmp_s -lt $zero_s
                set tmp (math "$tmp + 6")
            end
            set hval (math "$tmp / 6")
        else if test $g_s -eq $maxc_s
            set hval (math "(($b - $r) / $d + 2) / 6")
        else
            set hval (math "(($r - $g) / $d + 4) / 6")
        end
    end

    # Adjust saturation by amount and clamp to [0,1]
    set s (math "$s + $amount")
    set -l s_s (math "floor($s * $scale)")
    if test $s_s -lt 0
        set s 0
    end
    set -l one_s $scale
    if test $s_s -gt $one_s
        set s 1
    end

    # Convert HLS back to RGB
    set -l r_out 0
    set -l g_out 0
    set -l b_out 0
    set -l s_s (math "floor($s * $scale)")
    if test $s_s -eq 0
        set r_out $l
        set g_out $l
        set b_out $l
    else
        set -l q
        set -l l_s (math "floor($l * $scale)")
        set -l half_s (math "floor(0.5 * $scale)")
        if test $l_s -lt $half_s
            set q (math "$l * (1 + $s)")
        else
            set q (math "$l + $s - $l * $s")
        end
        set -l p (math "2 * $l - $q")

        # Helper: compute one channel from t
        function __hue2rgb -a p -a q -a t --description 'internal helper'
            set -l p $p; set -l q $q; set -l t $t
            set -l scale 1000000
            set -l t_s (math "floor($t * $scale)")
            set -l zero_s 0
            set -l one_s $scale
            set -l one_sixth_s (math "floor((1/6) * $scale)")
            set -l half_s (math "floor(0.5 * $scale)")
            set -l two_thirds_s (math "floor((2/3) * $scale)")

            if test $t_s -lt $zero_s
                set t (math "$t + 1")
                set t_s (math "floor($t * $scale)")
            end
            if test $t_s -gt $one_s
                set t (math "$t - 1")
                set t_s (math "floor($t * $scale)")
            end

            if test $t_s -lt $one_sixth_s
                printf "%s" (math "$p + ($q - $p) * 6 * $t")
            else if test $t_s -lt $half_s
                printf "%s" $q
            else if test $t_s -lt $two_thirds_s
                printf "%s" (math "$p + ($q - $p) * (2/3 - $t) * 6")
            else
                printf "%s" $p
            end
        end

        set -l t_r (math "$hval + 1/3")
        set -l t_g $hval
        set -l t_b (math "$hval - 1/3")

        set r_out (__hue2rgb $p $q $t_r)
        set g_out (__hue2rgb $p $q $t_g)
        set b_out (__hue2rgb $p $q $t_b)

        # remove helper
        functions -q  -e __hue2rgb >/dev/null 2>&1 || true
    end

    # Convert back to 0-255 integers (rounded)
    set -l r_i (math "round($r_out * 255)")
    set -l g_i (math "round($g_out * 255)")
    set -l b_i (math "round($b_out * 255)")

    # Print hex
    printf "#%02x%02x%02x\n" $r_i $g_i $b_i
end

