{ pkgs, ... }:
let
  version = "15.0.0";
  dlver   = "15";            # 15.0.0 -> "15", 15.1.0 -> "15.1"
    wolfram-engine = pkgs.wolfram-engine.overrideAttrs (old: {
    inherit version;
    src = pkgs.fetchurl {
      name   = "WolframEngine_${version}_LINUX.sh";
      url    = "https://account.wolfram.com/dl/WolframEngine?platform=Linux&version=${dlver}";
      sha256 = "5352d1e544db742a9ae493770e5b87e08abb605f8a7d96d9c77e585551c032ee";
    };
    # 15.x dropped some executables (e.g. mcc) that the 14.1 recipe wraps
    installPhase = ''
      makeWrapper() {
        if [ -e "$1" ]; then makeBinaryWrapper "$@"
        else echo "wolfram-engine: skipping missing $1"; fi
      }
    '' + old.installPhase;
  });
in {
  nixpkgs.config.allowUnfree = true;   # or an allowUnfreePredicate for just this
  environment.systemPackages = [ wolfram-engine ];
}
