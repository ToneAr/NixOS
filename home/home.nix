{ pkgs, username, ... }:

let
  # Import your standalone file and pass pkgs to it
  yamis-pkg = (import ../addons/yamis.nix { inherit pkgs; }).yet-another-monochrome-icon-set;
  breezex-pkg = (import ../addons/breezex.nix { inherit pkgs; }).breezex-cursor;
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.packages = [ yamis-pkg ];

  imports = [
    ./home-base.nix
    ../addons/applications.nix
    ./dotfiles.nix
    ../system/memory-limits.nix
    ./plasma.nix
    ./panels.nix
    ./hyprland.nix
    ../addons/kde-glass.nix
  ];

  # Theme assets that are not packaged in nixpkgs, copied from the Arch box.
  # (YAMIS is packaged in yamis.nix and installed above.)
  # BreezeX is fetched from its GitHub release in breezex.nix; ~/.icons is
  # where every toolkit and XWayland looks for cursors.
  home.file.".icons/BreezeX-Dark".source = "${breezex-pkg}/share/icons/BreezeX-Dark";
  home.file.".local/share/plasma/plasmoids/org.kde.windowtitle".source =
    ./../assets/org.kde.windowtitle;
  home.file.".config/panel-colorizer/presets".source =
    ./../assets/panel-colorizer-presets;

  home.stateVersion = "26.05";
}
