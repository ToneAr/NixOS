# General home-folder setup: XDG directories, session variables, and the
# environment bits that were scattered through ~/.config/fish/config.fish on
# the Arch box.
{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;
in
{
  # ---- XDG base directories -----------------------------------------
  xdg.enable = true;

  # Matches ~/.config/user-dirs.dirs from the old machine. Note XDG_PROJECTS_DIR
  # is not a standard XDG dir, so home-manager has no typed option for it; it
  # goes in extraConfig below.
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${home}/Desktop";
    documents = "${home}/Documents";
    download = "${home}/Downloads";
    music = "${home}/Music";
    pictures = "${home}/Pictures";
    publicShare = "${home}/Public";
    templates = "${home}/Templates";
    videos = "${home}/Videos";
    extraConfig.XDG_PROJECTS_DIR = "${home}/Projects";
  };

  # ---- session variables --------------------------------------------
  # Translated from config.fish. The Arch-specific absolute paths are gone:
  # /opt/nvim-linux-x86_64/bin was a hand-unpacked tarball, and on NixOS nvim
  # comes from pkgs.neovim and is already on PATH.
  home.sessionVariables = {
    EDITOR = "nvim";          # was "code"; change back if you prefer VS Code
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    PAGER = "less";

    # Wayland / Qt behaviour carried over from the fish config.
    QT_WAYLAND_SHELL_INTEGRATION = "xdg-shell";

  };

  # `set -x TERM xterm-256color` from config.fish is deliberately dropped —
  # hard-setting TERM breaks ghostty's own terminfo. Let the terminal set it.

  home.sessionPath = [
    "${home}/.local/bin"      # wrapper scripts, prepended on Arch
    "${home}/.opencode/bin"
  ];

  # ---- direnv --------------------------------------------------------
  # Replaces `direnv hook fish | source`; the module wires the hook itself.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ---- git -----------------------------------------------------------
  programs.git = {
    enable = true;
    settings.user = {
      name = "Tony Aristeidou";
      email = "piponio16@googlemail.com";
    };
  };

  # Your fish aliases lean on delta heavily.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
