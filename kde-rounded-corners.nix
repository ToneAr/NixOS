{ pkgs, ... }:

{
  # Adds the KWin effect package globally to the system environment
  home.packages = [
    pkgs.kde-rounded-corners
  ];
}
