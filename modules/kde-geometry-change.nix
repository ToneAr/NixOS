{ pkgs, username, ... }:

let
  kwin-effects-geometry-change = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "kwin-effects-geometry-change";
    version = "1.5";

    src = pkgs.fetchFromGitHub {
      owner = "peterfajdiga";
      repo = "kwin4_effect_geometry_change";
      rev = "v${version}";
      hash = "sha256-p4FpqagR8Dxi+r9A8W5rGM5ybaBXP0gRKAuzigZ1lyA=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/kwin/effects
      cp -r package $out/share/kwin/effects/kwin4_effect_geometry_change
    '';
  };
in
{
  users.users.${username}.packages = [ kwin-effects-geometry-change ];
}
