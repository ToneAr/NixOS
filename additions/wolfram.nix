# Wolfram / Mathematica setup carried over from the Arch box, as one switch:
#
#   wolfram.enable = true;     # in configuration.nix
#
# Wolfram itself is NOT installed by Nix. As on Arch, install it with the
# official installer into ~/Wolfram/Wolfram/<version>; this module wires up
# everything around that install:
#   - nix-ld libraries so the prebuilt FrontEnd/kernel binaries run
#   - env vars (MATHEMATICA_HOME, WSTP_*) and `wolframscript` on PATH
#   - desktop entry (com.wolfram.Wolfram.<version>) + Ctrl+Alt+M in Plasma
#     and Hyprland
#   - the kernel pool (wstpserver), kernel warmer and CRIU snapshot services,
#     plus their helper scripts in ~/.local/bin (from assets/wolfram/bin)
#   - criu with checkpoint/restore capabilities (on Arch the setcap step had
#     never been done, so the snapshot daemon could not actually restore)
#   - the /etc/hosts pins for wolfram.com domains
#
# Not carried over: wolfie/wolfsh/wstp.node/WSTPServerManager (your own
# binaries in ~/.local; copy them over and nix-ld runs them), the Wolfram
# kwin rules and the "wolfram folders" panel.
{ config, lib, pkgs, username, ... }:
let
  cfg = config.wolfram;
  home = "/home/${username}";
  wolframHome = "${home}/Wolfram/Wolfram/${cfg.version}";
  exe = "${wolframHome}/Executables";
  wstpDir = "${wolframHome}/SystemFiles/Links/WSTP/DeveloperKit/Linux-x86-64/CompilerAdditions";
  desktopId = "com.wolfram.Wolfram.${cfg.version}";

  # The Arch scripts hardcode the 15.1 install path; point them at cfg.version.
  script = name: {
    executable = true;
    text = builtins.replaceStrings
      [ "/home/tonya/Wolfram/Wolfram/15.1" ]
      [ wolframHome ]
      (builtins.readFile (../assets/wolfram/bin + "/${name}"));
  };

  # User services on NixOS have no /usr/bin; give them the same tools a login
  # shell sees, with the capability-wrapped criu first.
  servicePath = lib.concatStringsSep ":" [
    "/run/wrappers/bin"
    "${home}/.local/bin"
    "/etc/profiles/per-user/${username}/bin"
    "/run/current-system/sw/bin"
  ];
in
{
  options.wolfram = {
    enable = lib.mkEnableOption "the Wolfram/Mathematica desktop setup";
    version = lib.mkOption {
      type = lib.types.str;
      default = "15.1";
      description = "Directory name of the install under ~/Wolfram/Wolfram.";
    };
  };

  config = lib.mkIf cfg.enable {
    # ---- system side ---------------------------------------------------
    # Library set taken from nixpkgs' own mathematica package (minus the
    # optional heavy extras: opencv, openjdk, llvm, CUDA).
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        alsa-lib cups.lib dbus fontconfig freetype glib gmpxx keyutils.lib
        libGL libGLU libpcap libuuid libxkbcommon libxml2 mpfr ncurses
        openssl pciutils tre unixodbc zlib stdenv.cc.cc.lib
        libxcb libxcb-image libxcb-keysyms
        libice libsm libx11 libxscrnsaver libxcomposite libxcursor libxdamage
        libxext libxfixes libxi libxinerama libxmu libxrandr libxrender libxtst
      ];
    };

    security.wrappers.criu = {
      owner = "root";
      group = "root";
      capabilities = "cap_checkpoint_restore,cap_sys_ptrace+eip";
      source = "${pkgs.criu}/bin/criu";
    };

    networking.hosts = {
      "140.177.52.200" = [ "reference.wolfram.com" "wolframalpha.com" "www.wolframalpha.com" ];
      "140.177.50.65" = [ "wolframcloud.com" "www.wolframcloud.com" ];
    };

    # ---- user side -----------------------------------------------------
    home-manager.users.${username} = { config, ... }: {
      home.packages = [ pkgs.python3 ];   # snapshot daemon + WSTP proxy

      home.sessionVariables = {
        MATHEMATICA_HOME = wolframHome;
        WSTP_COMPILER_ADDITIONS_DIRECTORY = wstpDir;
        WSTP_DIR = wstpDir;
        # From nixpkgs' mathematica wrapper: bundled Qt needs these on NixOS.
        USE_WOLFRAM_LD_LIBRARY_PATH = "1";
        QT_XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
      };

      home.file = {
        # Was /usr/bin/wolframscript -> the install, from wolfram-system-integration.
        ".local/bin/wolframscript".source =
          config.lib.file.mkOutOfStoreSymlink "${exe}/wolframscript";
        ".local/bin/WolframKernel" = script "WolframKernel";
        ".local/bin/wolfram-kernel-warmer" = script "wolfram-kernel-warmer";
        ".local/bin/wolfram-snapshot-create" = script "wolfram-snapshot-create";
        ".local/bin/wolfram-snapshot-daemon" = script "wolfram-snapshot-daemon";
        ".local/bin/wolfram-wstp-proxy" = script "wolfram-wstp-proxy";
      };

      xdg.configFile."wstpserver/wstpserver.conf".text = builtins.toJSON {
        AllowSilentKernelReplacement = true;
        EnableAutomaticKernelConnection = false;
        SendInputNamePacketUponKernelConnection = true;
        Pools.Main = {
          Default = true;
          KernelPath = "${exe}/WolframKernel";
          KeepAlive = false;
          MinimumKernelNumber = 2;
          MaximumKernelNumber = 2;
        };
      };

      # Replaces /usr/share/applications/com.wolfram.Wolfram.15.1.desktop. The
      # id has to match the Plasma shortcut below.
      xdg.desktopEntries.${desktopId} = {
        name = "Wolfram ${cfg.version}";
        exec = "${exe}/WolframNB --name ${desktopId} %F";
        icon = "${wolframHome}/SystemFiles/FrontEnd/SystemResources/X/App-128.png";
        categories = [ "Science" "Math" "Education" ];
        mimeType = [
          "application/vnd.wolfram.nb" "application/vnd.wolfram.cdf"
          "application/vnd.wolfram.player" "application/vnd.wolfram.mathematica.package"
          "application/vnd.wolfram.wl" "application/vnd.wolfram.wls"
          "application/mathematica" "application/x-mathematica"
        ];
      };

      programs.plasma.shortcuts."services/${desktopId}.desktop"._launch = "Ctrl+Alt+M";
      wayland.windowManager.hyprland.settings.bind = [
        "CTRL ALT, M, exec, ${exe}/WolframNB -platform xcb -singleLaunch"
      ];

      systemd.user.services = {
        wstpserver = {
          Unit = {
            Description = "Wolfram Kernel Pool (WSTPServer)";
            After = [ "network.target" ];
          };
          Service = {
            ExecStart = lib.concatStringsSep " " [
              "${wolframHome}/SystemFiles/Links/WSTPServer/wstpserver"
              "-p 31415 -i localhost"
              "-c %h/.config/wstpserver/wstpserver.conf"
              "-l 1 -f %h/.local/share/wstpserver/wstpserver.log"
            ];
            Restart = "on-failure";
          };
          Install.WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
