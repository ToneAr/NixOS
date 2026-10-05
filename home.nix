{ pkgs, username, ... }:

let
  # Import your standalone file and pass pkgs to it
  yamis-pkg = (import ./yamis.nix { inherit pkgs; }).yet-another-monochrome-icon-set;
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.packages = [ yamis-pkg ];

  imports = [
    ./home-base.nix    # XDG dirs, session variables, git, direnv
    ./applications.nix # App set
    ./dotfiles.nix     # nvim, fish, ghostty, waybar, rofi, ... from Arch
    ./memory-limits.nix # zen.slice + kwin memory cap
    ./plasma.nix       # Plasma settings, shortcuts, kwin rules
    ./panels.nix       # Plasma panels
    ./hyprland.nix     # Hyprland session
    ./kde-rounded-corners.nix
    ./klassy.nix
    ./kde-glass.nix
  ];

  # Theme assets that are not packaged in nixpkgs, copied from the Arch box.
  # (YAMIS is packaged in yamis.nix and installed above.)
  home.file.".icons/BreezeX-Dark".source = ./assets/BreezeX-Dark;
  home.file.".local/share/plasma/plasmoids/org.kde.windowtitle".source =
    ./assets/org.kde.windowtitle;
  home.file.".config/panel-colorizer/presets".source =
    ./assets/panel-colorizer-presets;

  home.stateVersion = "26.05";
}
