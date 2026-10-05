# Commonly used applications.
#
# This is NOT a transcription of `pacman -Qe` — that was 500 packages, mostly
# the entire KDE application suite pulled in by group installs. This is the set
# with actual evidence of use: referenced by your Hyprland binds, your Plasma
# panel launchers, your Plasma autostart entries, or your fish config.
#
# Every attribute here was checked against nixpkgs before being written down.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ---- terminals -------------------------------------------------
    ghostty                     # $terminal in hyprland.conf
    kitty
    kdePackages.yakuake
    kdePackages.krohnkite
    kdePackages.kmail
    evolution

    # ---- browsers --------------------------------------------------
    firefox                     # launched by exec-once
    google-chrome

    # ---- editors / IDEs --------------------------------------------
    neovim
    vscode                      # visual-studio-code-bin on Arch (vscodium
                                # dropped: Arch has no VSCodium, and both
                                # ship lib/vscode, so they clash)
    code-cursor                 # cursor-bin on Arch
    zed-editor                  # bound to CTRL+ALT+C
    kdePackages.kate
    kdePackages.kdevelop

    # ---- notes / office --------------------------------------------
    obsidian                    # bound to CTRL+ALT+O, also a panel launcher
    wpsoffice

    # ---- comms -----------------------------------------------------
    rocketchat-desktop          # in Plasma autostart + a float windowrule
    zoom-us                     # in Plasma autostart + a float windowrule
    kdePackages.konversation
    discord
    # kdePackages.neochat  -- DISABLED: pulls libolm (olm-3.2.16), which nixpkgs
    # marks insecure; libolm is deprecated and unmaintained upstream. Enabling
    # it means adding "olm-3.2.16" to nixpkgs.config.permittedInsecurePackages.
    # Use a vodozemac-based Matrix client (e.g. fractal, element-desktop) instead.

    # ---- Hyprland session ------------------------------------------
    waybar                      # exec-once
    rofi                        # $menu, and ClipManager.sh  (rofi 2.x = wayland)
    # swaynotificationcenter is NOT installed into the profile on purpose:
    # its D-Bus service file would let it grab org.freedesktop.Notifications
    # inside Plasma (Arch needed swaync.service.d/override.conf for this).
    # hyprland.nix runs it by store path instead.
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
    kdePackages.dolphin         # $fileManager
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    # kdeconnect-kde comes from programs.kdeconnect in configuration.nix
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.kdenlive
    kdePackages.elisa
    # kreadconfig6 lives here — your fish theme functions call kreadconfig5,
    # which does not exist on Plasma 6. See the note in the summary.
    kdePackages.kconfig

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
    imagemagick                 # `convert`, used by the theme functions
    claude-code

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

    # ---- virt / remote ---------------------------------------------
    remmina                     # remmina-applet was in Plasma autostart
    # virt-manager comes from programs.virt-manager in configuration.nix

    # ---- media -----------------------------------------------------
    vlc
  ];
}
