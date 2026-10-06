# Commonly used applications.
#
# This is NOT a transcription of `pacman -Qe` — that was 500 packages, mostly
# the entire KDE application suite pulled in by group installs. This is the set
# with actual evidence of use: referenced by your Hyprland binds, your Plasma
# panel launchers, your Plasma autostart entries, or your fish config.
#
# Every attribute here was checked against nixpkgs before being written down.
{ pkgs, username, ... }:
{
  users.users.${username}.packages = with pkgs; [
    # ---- compilers -------------------------------------------------
    (lib.hiPrio gcc)
    clang
    clang-tools
    binutils
    python3
    nodejs
    bun
    gnumake
    cmake
    ninja
    meson
    pkg-config
    autoconf
    automake
    libtool
    bear

    # ---- browsers --------------------------------------------------
    firefox
    google-chrome

    # ---- shell / CLI -----------------------------------------------
    fish
    oh-my-posh
    delta
    fd
    ripgrep
    jq
    tmux
    yazi
    btop
    htop
    imagemagick
    claude-code
    claude-agent-acp            # ACP bridge: CodeCompanion <-> Claude Code
    codex
    codex-acp                   # ACP bridge: CodeCompanion <-> Codex

    # ---- dev -------------------------------------------------------
    gh
    lazygit
    lazydocker
    opencode
    powershell                  # was a snap on Arch
    nodejs
    pnpm
    go
    rustup
    ollama
    gitkraken

    # ---- debugging -------------------------------------------------
    gdb
    lldb
    valgrind

    # ---- nix -------------------------------------------------------
    nixd
    nixfmt

    # ---- terminals -------------------------------------------------
    ghostty
    kitty
    kdePackages.yakuake
    kdePackages.krohnkite
    kdePackages.kmail
    evolution

    # ---- editors / IDEs --------------------------------------------
    neovim
    lua5_1                      # for lazy.nvim luarocks support (hererocks can't build on NixOS)
    lua51Packages.luarocks
    vscode
    code-cursor
    zed-editor
    kdePackages.kate
    kdePackages.kdevelop

    # ---- notes / office --------------------------------------------
    obsidian
    wpsoffice

    # ---- comms -----------------------------------------------------
    rocketchat-desktop
    zoom-us
    kdePackages.konversation
    discord

    # ---- Hyprland session ------------------------------------------
    waybar                      # exec-once
    rofi                        # $menu, and ClipManager.sh  (rofi 2.x = wayland)
    cliphist                    # exec-once clipboard history
    wl-clipboard                # wl-paste / wl-copy
    playerctl                   # media key binds
    brightnessctl               # brightness binds
    wlogout                     # Wlogout.sh
    hyprpaper                   # exec-once  (also enabled as a service)
    hyprlock                    # LockScreen.sh
    nwg-displays                # what generated monitors.conf
    wallust                     # generates the sourced colour file
    grim                        # screenshots
    slurp
    kdePackages.spectacle       # Mod+Shift+S bind uses spectacle specifically
    networkmanagerapplet        # nm-applet --indicator
    libnotify                   # notify-send, used by AirplaneMode.sh
    pavucontrol                 # waybar pulseaudio on-click
    blueman                     # waybar bluetooth on-click (blueman-manager)

    # ---- KDE apps you actually use ---------------------------------
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.kdenlive
    kdePackages.elisa
    kdePackages.kconfig
    # Upstream hardcodes krunner as an exception, so its Plasma background
    # kept square-ish corners poking out past the glass effect's rounding.
    (kde-rounded-corners.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace src/WindowManager.cpp \
          --replace-fail 'QStringLiteral("krunner"),' ""
      '';
    }))

    # ---- virt / remote ---------------------------------------------
    remmina

    # ---- media -----------------------------------------------------
    vlc
  ];
}
