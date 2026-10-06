{ pkgs, username, ... }:

# klassy-dark-glass / klassy-light-glass: the Klassy Plasma styles with a
# dialog background (launcher, tray popups, KRunner, ...) that matches the
# Panel Colorizer panels: the View background colour at 30% over the glass
# blur, instead of Breeze's Window background at 85%.
let
  breezeDialog = "${pkgs.kdePackages.libplasma}/share/plasma/desktoptheme/default/translucent/dialogs/background.svgz";

  mkGlassTheme = variant: pkgs.runCommand "klassy-${variant}-glass-plasma-theme" {
    nativeBuildInputs = [ pkgs.jq ];
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
