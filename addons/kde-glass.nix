{ pkgs, ... }:

let
  kwin-effects-glass = pkgs.stdenv.mkDerivation rec {
    pname = "kwin-effects-glass";
    version = "0-unstable-32f1e79";

    src = pkgs.fetchFromGitHub {
      owner = "4v3ngR";
      repo = "kwin-effects-glass";
      rev = "32f1e79f517eef992563856aa06963f6ee8455b9";
      sha256 = "sha256-QMIscGqrEv8X5JbOkHk2SZw+OuyQOFdFzYYsiYgs1MI=";
    };

    # Blur behind windows made translucent by a KWin opacity rule, even when
    # the client (Chromium/Electron/Firefox on Wayland) declares itself opaque.
    patches = [ ../patches/kde-glass-translucent.patch ];

    nativeBuildInputs = with pkgs; [
      cmake
      kdePackages.extra-cmake-modules
      pkg-config
    ];

    buildInputs = with pkgs; [
      kdePackages.kwin
      kdePackages.kcoreaddons
      kdePackages.kconfigwidgets
      kdePackages.kwindowsystem
      libsysprof-capture
    ];

    dontWrapQtApps = true;

    # Installs the compiled binaries into the correct system path for KWin to discover
    cmakeFlags = [
      "-DCMAKE_INSTALL_PREFIX=$out"
    ];
  };
in
{
  home.packages = [ kwin-effects-glass ];
}
