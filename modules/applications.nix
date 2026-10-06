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
    claude-agent-acp
    codex
    codex-acp

    # ---- dev -------------------------------------------------------
    gh
    lazygit
    lazydocker
    opencode
    powershell
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
    lua5_1
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
    waybar
    rofi
    cliphist
    wl-clipboard
    playerctl
    brightnessctl
    wlogout
    hyprpaper
    hyprlock
    nwg-displays
    wallust
    grim
    slurp
    kdePackages.spectacle
    networkmanagerapplet
    libnotify
    pavucontrol
    blueman

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
