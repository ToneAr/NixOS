Files that are not packaged in nixpkgs, copied from the Arch box.

  org.kde.windowtitle/     Plasma widget         -> ~/.local/share/plasma/plasmoids (home.nix)
  panel-colorizer-presets/ Panel Colorizer       -> ~/.config/panel-colorizer/presets (home.nix)
  wallpapers/              hyprpaper wallpaper   (hyprland.nix)
  hypr-scripts/            scripts Hyprland binds call (hyprland.nix)
  dotfiles/                ghostty, kitty, waybar, rofi, swaync,
                           wlogout, wallust, omp.json (dotfiles.nix)
  wolfram/bin/             Wolfram helper scripts (wolfram.nix, only when enabled)
  wolfie/                  wolfie config + theme, copied once if missing (wolfie.nix)
  seeds/                   wallust output, copied once if missing (dotfiles.nix)
