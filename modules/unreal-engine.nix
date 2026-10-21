# Unreal Engine 5 editor, run from a hand-installed prebuilt build:
#
#   unrealEngine.enable = true;   # in configuration.nix
#
# Unreal is NOT installed by Nix: it is not in nixpkgs and the download needs
# an Epic account. Get "Linux_Unreal_Engine_<version>.zip" from
# https://www.unrealengine.com/linux and unzip it into `unrealEngine.directory`
# (the folder that contains `Engine/`). This module wires up the rest:
#   - `unreal-editor`: the editor inside an FHS env, so its bundled binaries,
#     .NET and clang toolchain find the libraries they expect
#   - a desktop entry for the editor
#   - a larger inotify watch limit (the editor watches the whole project)
{ config, lib, pkgs, username, ... }:
let
  cfg = config.unrealEngine;
  editorBinary = "${cfg.directory}/Engine/Binaries/Linux/UnrealEditor";

  unrealEditor = pkgs.buildFHSEnv {
    name = "unreal-editor";
    targetPkgs = pkgs: with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      icu
      krb5
      libuuid
      nss
      nspr
      dbus
      glib
      gtk3
      fontconfig
      freetype
      libGL
      vulkan-loader
      libdrm
      mesa
      wayland
      libxkbcommon
      libx11
      libxcursor
      libxrandr
      libxi
      libxext
      libxinerama
      libxrender
      libxscrnsaver
      libxxf86vm
      alsa-lib
      libpulseaudio
      pipewire
      udev
      xdg-utils
      which
      python3
    ];
    runScript = pkgs.writeShellScript "unreal-editor" ''
      if [ ! -x ${lib.escapeShellArg editorBinary} ]; then
        echo "Unreal Engine not found at ${cfg.directory}." >&2
        echo "Unzip the Linux build from https://www.unrealengine.com/linux there." >&2
        exit 1
      fi
      exec ${lib.escapeShellArg editorBinary} "$@"
    '';
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "unreal-editor";
    desktopName = "Unreal Editor";
    genericName = "Game Engine";
    exec = "${unrealEditor}/bin/unreal-editor %f";
    icon = "applications-games";
    categories = [ "Development" "Game" ];
    startupWMClass = "UnrealEditor";
  };
in
{
  options.unrealEngine = {
    enable = lib.mkEnableOption "the Unreal Engine 5 editor wrapper";
    directory = lib.mkOption {
      type = lib.types.str;
      default = "/home/${username}/UnrealEngine";
      description = "Where the prebuilt Linux build is unzipped (contains `Engine/`).";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl."fs.inotify.max_user_watches" = lib.mkDefault 524288;

    users.users.${username}.packages = [ unrealEditor desktopItem ];
  };
}
