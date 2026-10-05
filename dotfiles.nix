# Dotfiles copied from the Arch box into ./assets/dotfiles.
#
# Every directory is linked with `recursive = true`: the directory itself is a
# normal writable folder and only the files inside are store symlinks. That
# matters because several tools write next to their config at runtime:
#   nvim     lazy.nvim writes lazy-lock.json (deliberately not shipped)
#   fish     fish_variables, plus proj_setup/omp_setup clone into repos/
#   wallust  writes generated colour files into rofi/, waybar/, hypr/
#
# Files that wallust regenerates are shipped as one-time seeds instead (see
# home.activation below), so they exist on first login and wallust can
# overwrite them afterwards.
{ config, lib, pkgs, ... }:
let
  dots = ./assets/dotfiles;
  seeds = ./assets/seeds;
  linkDir = name: { source = "${dots}/${name}"; recursive = true; };
in
{
  xdg.configFile = {
    "nvim" = linkDir "nvim";
    "ghostty" = linkDir "ghostty";
    "kitty" = linkDir "kitty";
    "waybar" = linkDir "waybar";
    "rofi" = linkDir "rofi";
    "swaync" = linkDir "swaync";
    "wlogout" = linkDir "wlogout";
    "wallust" = linkDir "wallust";
    "fish/functions" = linkDir "fish/functions";
    "fish/conf.d" = linkDir "fish/conf.d";
    "omp.json".source = "${dots}/omp.json";
  };

  # ---- fish ----------------------------------------------------------
  # Replaces ~/.config/fish/config.fish. PATH, EDITOR, the direnv hook and
  # `ulimit -n` are handled in home-base.nix / configuration.nix instead.
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # API keys and other secrets stay out of the Nix store. Copy
      # secrets.fish over by hand (chmod 600) if you want it.
      if test -f ~/.config/fish/secrets.fish
          source ~/.config/fish/secrets.fish
      end

      proj_setup
      omp_setup
      system_theme_sync
      fish_theme_watch
    '';
  };

  # ---- one-time seeds for runtime-generated files --------------------
  home.activation.seedMutableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    seed() {
      if [ ! -e "$2" ]; then
        run install -Dm644 "$1" "$2"
      fi
    }
    seed ${seeds}/colors-rofi.rasi        "$HOME/.config/rofi/wallust/colors-rofi.rasi"
    seed ${seeds}/colors-waybar.css      "$HOME/.config/waybar/wallust/colors-waybar.css"
    seed ${seeds}/wallust-hyprland.conf  "$HOME/.cache/wallust/hyprland.conf"
    # nwg-displays owns this file; start from a single-screen fallback.
    if [ ! -e "$HOME/.config/hypr/monitors.conf" ]; then
      run mkdir -p "$HOME/.config/hypr"
      run sh -c 'echo "monitor=,preferred,auto,1" > "$HOME/.config/hypr/monitors.conf"'
    fi
  '';
}
