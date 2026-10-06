{ pkgs, username, ... }:

let
  # Not in nixpkgs; the prebuilt X11/Wayland theme from the GitHub release.
  breezex-cursor = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "breezex-cursor";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v${version}/BreezeX-Dark.tar.xz";
      hash = "sha256-jN90NGaw8VZf5fKQ3UjvTALZF3hFjQ08xWQ3UVJVtlM=";
    };

    sourceRoot = ".";
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/icons
      cp -r BreezeX-Dark $out/share/icons/
    '';
  };
in
{
  users.users.${username}.packages = [ breezex-cursor ];

  # ~/.icons is where every toolkit and XWayland looks for cursors.
  home-manager.users.${username}.home.file.".icons/BreezeX-Dark".source =
    "${breezex-cursor}/share/icons/BreezeX-Dark";
}
