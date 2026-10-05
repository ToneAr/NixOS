function rotate_hue -d "Rotate hue by degrees" -a hex -a degrees
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

    # scale floats to integers for comparisons
    set -l scale 1000000
    set -l r_s (math "floor($r * $scale)")
    set -l g_s (math "floor($g * $scale)")
    set -l b_s (math "floor($b * $scale)")

    # RGB -> HLS
    set -l max $r
    set -l max_s $r_s
    if test $g_s -gt $max_s
        set max $g
        set max_s $g_s
    end
    if test $b_s -gt $max_s
        set max $b
        set max_s $b_s
    end

    set -l min $r
    set -l min_s $r_s
    if test $g_s -lt $min_s
        set min $g
        set min_s $g_s
    end
    if test $b_s -lt $min_s
        set min $b
        set min_s $b_s
    end

    set -l l (math "($max + $min) / 2")
    set -l diff (math "$max - $min")
    set -l diff_s (math "floor($diff * $scale)")

    set -l h 0
    set -l s 0
    if test $diff_s -ne 0
        set -l l_s (math "floor($l * $scale)")
        set -l half_s (math "floor(0.5 * $scale)")
        if test $l_s -gt $half_s
            set s (math "$diff / (2 - $max - $min)")
        else
            set s (math "$diff / ($max + $min)")
        end

        set -l h_tmp 0
        if test $r_s -eq $max_s
            set h_tmp (math "($g - $b) / $diff")
            set -l h_tmp_s (math "floor($h_tmp * $scale)")
            set -l zero_s 0
            if test $h_tmp_s -lt $zero_s
                set h_tmp (math "$h_tmp + 6")
            end
        else if test $g_s -eq $max_s
            set h_tmp (math "($b - $r) / $diff + 2")
        else
            set h_tmp (math "($r - $g) / $diff + 4")
        end

        set h (math "$h_tmp / 6")
    end

    # rotate hue by degrees and keep fractional part
    set -l h (math "($h + $degrees / 360) - floor(($h + $degrees / 360))")

    # HLS -> RGB
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

        # helper: compute channel from hue
        function __hue2rgb -a p -a q -a t --no-scope
            set -l p $p; set -l q $q; set -l t $t
            set -l scale 1000000
            set -l t_s (math "floor($t * $scale)")
            set -l zero_s 0
            set -l one_s $scale
            set -l one_sixth_s (math "floor((1/6) * $scale)")
            set -l half_s (math "floor(0.5 * $scale)")
            set -l two_thirds_s (math "floor((2/3) * $scale)")
            
            # wrap t
            if test $t_s -lt $zero_s
                set t (math "$t + 1")
                set t_s (math "floor($t * $scale)")
            end
            if test $t_s -gt $one_s
                set t (math "$t - 1")
                set t_s (math "floor($t * $scale)")
            end

            if test $t_s -lt $one_sixth_s
                echo (math "$p + ($q - $p) * 6 * $t")
            else if test $t_s -lt $half_s
                echo $q
            else if test $t_s -lt $two_thirds_s
                echo (math "$p + ($q - $p) * (0.6666666666666666 - $t) * 6")
            else
                echo $p
            end
        end

        set -l t_r (math "$h + 0.3333333333333333")
        set -l t_g $h
        set -l t_b (math "$h - 0.3333333333333333")

        set r_out (__hue2rgb $p $q $t_r)
        set g_out (__hue2rgb $p $q $t_g)
        set b_out (__hue2rgb $p $q $t_b)

        # remove helper to avoid polluting namespace
        functions -e __hue2rgb
    end

    # RGB (0..1) -> hex
    set -l ri (math "round($r_out * 255)")
    set -l gi (math "round($g_out * 255)")
    set -l bi (math "round($b_out * 255)")
    printf '#%02x%02x%02x\n' $ri $gi $bi
end

