{ pkgs, ... }:
let
  version = "3.1.4";
  pname = "wljs-notebook";
  src = pkgs.fetchurl {
    url = "https://github.com/WLJSTeam/wljs-notebook/releases/download/v${version}/wljs-notebook-${version}-x86_64-gnulinux.AppImage";
    hash = "sha256-UOcgXdBHfUep/VnhxHVPhnqdBzOKv57vOP+4uCA0lbI=";   # build once, then paste the real hash from the error
  };
  contents = pkgs.appimageTools.extractType2 { inherit pname version src; };

  wljs = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = p: with p; [ libuv ];
    extraInstallCommands = ''
      # pick up the bundled .desktop file and icon, if present
      if [ -f ${contents}/*.desktop ]; then
        install -Dm444 ${contents}/*.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/*.desktop \
          --replace-quiet 'Exec=AppRun' 'Exec=${pname}'
      fi
      cp -r ${contents}/usr/share/icons $out/share/ 2>/dev/null || true
    '';
  };
in {
  environment.systemPackages = [ wljs ];
}
