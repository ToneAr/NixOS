{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  # ---- XDG base directories -----------------------------------------
  xdg.enable = true;
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
  home.sessionVariables = {
    EDITOR = "nvim";          # was "code"; change back if you prefer VS Code
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    PAGER = "less";
    QT_WAYLAND_SHELL_INTEGRATION = "xdg-shell";
  };

  # ---- session path --------------------------------------------------
  home.sessionPath = [
    "${home}/.local/bin"      # wrapper scripts, prepended on Arch
    "${home}/.opencode/bin"
  ];

  # ---- direnv --------------------------------------------------------
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ---- git -----------------------------------------------------------
  programs.git = {
    enable = true;
    settings.user = {
      name = "ToneAr";
      email = "tonyaris@outlook.com";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
