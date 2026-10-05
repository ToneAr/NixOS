# Dotfiles copied from the Arch box into ./assets/dotfiles, plus the nvim and
# fish configs, which live in their own GitHub repos (see configRepos below).
#
# Every asset directory is linked with `recursive = true`: the directory itself
# is a normal writable folder and only the files inside are store symlinks.
# That matters because several tools write next to their config at runtime:
#   wallust  writes generated colour files into rofi/, waybar/, hypr/
#
# Files that wallust regenerates are shipped as one-time seeds instead (see
# home.activation below), so they exist on first login and wallust can
# overwrite them afterwards.
{ config, lib, pkgs, ... }:
let
  dots = ../assets/dotfiles;
  seeds = ../assets/seeds;
  linkDir = name: { source = "${dots}/${name}"; recursive = true; };

  # nvim and fish are editable git checkouts, not store copies: edit, commit
  # and push in place, update with `git pull`. They are cloned once if missing
  # and never touched again, so local changes are never overwritten.
  #   nvim  cloned straight into ~/.config/nvim.
  #   fish  cloned beside ~/.config/fish, because home-manager owns
  #         config.fish there (the repo's config.fish is the Arch one and is
  #         not used). functions/ and conf.d/ are symlinked into the checkout.
  #         proj_setup/omp_setup resolve paths through that symlink, so
  #         repos/ and proj.fish land in the checkout, where they are ignored.
  fishCheckout = "${config.xdg.dataHome}/fish-config";
  configRepos = [
    { repo = "ToneAr/.neovim"; dir = "${config.xdg.configHome}/nvim"; }
    { repo = "ToneAr/.fish"; dir = fishCheckout; }
  ];

  # Clones over https so it works before SSH keys are set up; pushes go over
  # ssh, like the proj/omp clones in the fish functions. Anything already at
  # the target that is not a git checkout (e.g. the old store-linked config)
  # is moved aside, not deleted.
  clone-config-repos = pkgs.writeShellScript "clone-config-repos" ''
    set -eu
    export PATH=${lib.makeBinPath [ pkgs.git pkgs.coreutils ]}
    clone() {
      repo=$1 dir=$2
      [ -d "$dir/.git" ] && return 0
      if [ -e "$dir" ] || [ -L "$dir" ]; then
        mv "$dir" "$dir.pre-git-$(date +%Y%m%d-%H%M%S)"
      fi
      mkdir -p "$(dirname "$dir")"
      git clone "https://github.com/$repo.git" "$dir"
      git -C "$dir" remote set-url --push origin "git@github.com:$repo.git"
    }
    ${lib.concatMapStrings (r: ''
      clone ${lib.escapeShellArg r.repo} ${lib.escapeShellArg r.dir}
    '') configRepos}
  '';
in
{
  # A retrying user service rather than an activation step, so a first boot
  # without network still ends up with the configs (same as wolfie.nix).
  systemd.user.services.clone-config-repos = {
    Unit = {
      Description = "Clone the nvim and fish config repos";
      StartLimitIntervalSec = 0;
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${clone-config-repos}";
      Restart = "on-failure";
      RestartSec = 60;
    };
    Install.WantedBy = [ "default.target" ];
  };

  xdg.configFile = {
    "ghostty" = linkDir "ghostty";
    "kitty" = linkDir "kitty";
    "waybar" = linkDir "waybar";
    "rofi" = linkDir "rofi";
    "swaync" = linkDir "swaync";
    "wlogout" = linkDir "wlogout";
    "wallust" = linkDir "wallust";
    "fish/functions".source =
      config.lib.file.mkOutOfStoreSymlink "${fishCheckout}/functions";
    "fish/conf.d".source =
      config.lib.file.mkOutOfStoreSymlink "${fishCheckout}/conf.d";
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
