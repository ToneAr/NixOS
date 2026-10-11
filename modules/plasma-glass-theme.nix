{ pkgs, username, ... }:

# klassy-dark-glass / klassy-light-glass: the Klassy Plasma styles with a
# dialog background (launcher, tray popups, KRunner, ...) that matches the
# Panel Colorizer panels: the View background colour at 30% over the glass
# blur, instead of Breeze's Window background at 85%.
let
  breezeDialog = "${pkgs.kdePackages.libplasma}/share/plasma/desktoptheme/default/translucent/dialogs/background.svgz";

  # Corner radius of list/menu highlights (Breeze uses 5); the glass windows
  # around them are 20.
  highlightRadius = 10;

  mkGlassTheme = variant: pkgs.runCommand "klassy-${variant}-glass-plasma-theme" {
    nativeBuildInputs = [ pkgs.jq pkgs.python3 ];
  } ''
    dir=$out/share/plasma/desktoptheme/klassy-${variant}-glass
    mkdir -p $(dirname $dir)
    cp -r ${pkgs.klassy}/share/plasma/desktoptheme/klassy-${variant} $dir
    chmod -R u+w $dir

    jq '.KPlugin.Id = "klassy-${variant}-glass"
        | .KPlugin.Name += " Glass"
        | del(.KPlugin["Name[fr]"], .KPlugin["Description[fr]"])' \
      $dir/metadata.json > metadata.json
    mv metadata.json $dir/metadata.json

    # Swap the frame fill to ViewBackground at 30% (what Panel Colorizer uses)
    # and drop the extra 1px edge highlight; shadows and masks stay as-is.
    gunzip -c ${breezeDialog} \
      | sed -e 's/class="ColorScheme-Background"/class="ColorScheme-ViewBackground"/g' \
            -e 's/opacity:0\.85/opacity:0.3/g' \
            -e 's/style="opacity:0\.5;fill:currentColor"/style="opacity:0;fill:currentColor"/g' \
      | gzip -9n > background.svgz
    for d in dialogs translucent/dialogs; do
      mkdir -p $dir/$d
      cp background.svgz $dir/$d/background.svgz
    done

    # Highlights (launcher, KRunner, tray popups, ...): Breeze's viewitem
    # styling (hover = 30% fill + 1px border, selected = 80% fill, both in
    # ButtonFocus) redrawn with a larger corner radius.
    mkdir -p $dir/widgets
    python3 - ${toString highlightRadius} <<'EOF' | gzip -9n > $dir/widgets/viewitem.svgz
    import sys

    R = float(sys.argv[1])
    parts = ["topleft", "top", "topright", "left", "center", "right",
             "bottomleft", "bottom", "bottomright"]
    # prefix: (fill opacity, border opacity or None)
    styles = {"normal": (0.005, None), "hover": (0.3, 1.0), "selected": (0.8, None)}

    def shape(part, x, y, border):
        """Fill (border=False) or 1px border ring (border=True) of one cell."""
        r, i = R, R - 1
        if part == "center":
            return None if border else f"M{x},{y}h{r}v{r}h{-r}z"
        if part in ("top", "bottom", "left", "right"):
            if not border:
                return f"M{x},{y}h{r}v{r}h{-r}z"
            return {"top": f"M{x},{y}h{r}v1h{-r}z",
                    "bottom": f"M{x},{y+r-1}h{r}v1h{-r}z",
                    "left": f"M{x},{y}h1v{r}h-1z",
                    "right": f"M{x+r-1},{y}h1v{r}h-1z"}[part]
        # Corners: quarter disc of radius R centred on the inner corner.
        cx = x + r if "left" in part else x
        cy = y + r if "top" in part else y
        sx = -1 if "left" in part else 1
        sy = -1 if "top" in part else 1
        a = (cx + sx * r, cy)            # point on the horizontal radius
        b = (cx, cy + sy * r)            # point on the vertical radius
        sweep = 1 if sx * sy > 0 else 0  # arc direction from a to b
        if not border:
            return (f"M{cx},{cy}L{a[0]},{a[1]}"
                    f"A{r},{r} 0 0 {sweep} {b[0]},{b[1]}z")
        a2 = (cx + sx * i, cy)
        b2 = (cx, cy + sy * i)
        return (f"M{a[0]},{a[1]}A{r},{r} 0 0 {sweep} {b[0]},{b[1]}"
                f"L{b2[0]},{b2[1]}A{i},{i} 0 0 {1 - sweep} {a2[0]},{a2[1]}z")

    out = ['<svg xmlns="http://www.w3.org/2000/svg" width="400" height="200">',
           '<style id="current-color-scheme" type="text/css">'
           '.ColorScheme-ButtonFocus{color:#1E92FF;}</style>']
    for row, (prefix, (fill, border)) in enumerate(styles.items()):
        ox, oy = 10, 10 + row * (3 * R + 10)
        for n, part in enumerate(parts):
            x, y = ox + (n % 3) * R, oy + (n // 3) * R
            out.append(f'<g id="{prefix}-{part}">')
            out.append(f'<path class="ColorScheme-ButtonFocus" '
                       f'style="fill:currentColor;opacity:{fill}" '
                       f'd="{shape(part, x, y, False)}"/>')
            ring = border and shape(part, x, y, True)
            if ring:
                out.append(f'<path class="ColorScheme-ButtonFocus" '
                           f'style="fill:currentColor;opacity:{border}" '
                           f'd="{ring}"/>')
            out.append('</g>')
    out.append('</svg>')
    print("\n".join(out))
    EOF
  '';

  # KlassyDarkGlass / KlassyLightGlass colour schemes: the Klassy schemes with
  # the Window background set to the View background (the panel tint), and the
  # [WM] title bar colour set to it at 30% alpha. Klassy takes title bar
  # opacity from that alpha and, with ApplyOpacityToHeader, extends it (with
  # blur) over the app's header/toolbar area.
  mkGlassColors = variant: let
    base = if variant == "dark" then "KlassyDark" else "KlassyLight";
    name = "${base}Glass";
  in pkgs.runCommand "${name}-color-scheme" {
    nativeBuildInputs = [ pkgs.python3 ];
  } ''
    mkdir -p $out/share/color-schemes
    python3 - ${pkgs.klassy}/share/color-schemes/${base}.colors \
      $out/share/color-schemes/${name}.colors <<'EOF'
    import configparser, sys

    src, dst = sys.argv[1:]
    cfg = configparser.ConfigParser(interpolation=None, strict=False)
    cfg.optionxform = str
    cfg.read(src)

    view = cfg["Colors:View"]
    cfg["Colors:Window"]["BackgroundNormal"] = view["BackgroundNormal"]
    cfg["Colors:Window"]["BackgroundAlternate"] = view["BackgroundAlternate"]

    tint = view["BackgroundNormal"] + ",77"  # 30% of 255
    cfg["WM"]["activeBackground"] = tint
    cfg["WM"]["inactiveBackground"] = tint

    general = cfg["General"]
    general["ColorScheme"] = "${name}"
    general["Name"] = general["Name"] + " Glass"
    for key in [k for k in general if k.startswith("Name[")]:
        del general[key]

    # configparser drops comments; keep the upstream licence header.
    header = []
    for line in open(src):
        if not line.startswith("#"):
            break
        header.append(line)

    with open(dst, "w") as f:
        f.writelines(header + ["\n"])
        cfg.write(f, space_around_delimiters=False)
    EOF
  '';
in
{
  users.users.${username}.packages = [
    (mkGlassTheme "dark") (mkGlassTheme "light")
    (mkGlassColors "dark") (mkGlassColors "light")
  ];
}
