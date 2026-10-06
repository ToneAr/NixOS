{ pkgs, username, ... }: # Arguments go first!

let
  yet-another-monochrome-icon-set = pkgs.stdenv.mkDerivation rec {
    pname = "yet-another-monochrome-icon-set";
    version = "1.4.3";

    src = pkgs.fetchFromGitHub {
      owner = "googIyEYES";
      repo = "YAMIS";
      rev = "24c02f6bb7bcd356e49df22f6942b078b66700fd";
      sha256 = "sha256-KZXG5XYHhUfgDrxOXT1mS+vbmH9l0uEzfdvOo1+r1TQ=";
    };

    nativeBuildInputs = [ pkgs.gtk3 ]; 
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/icons/
      tar -xzvf monochrome-icon-theme.tar.gz -C $out/share/icons/
      gtk-update-icon-cache $out/share/icons/* || true
    '';
  };
in
{
  users.users.${username}.packages = [ yet-another-monochrome-icon-set ];
}
