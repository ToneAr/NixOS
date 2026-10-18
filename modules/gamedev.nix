# Game development: engines, asset tools, graphics debugging, and the
# runtime plumbing (32-bit GL/Vulkan, nix-ld libraries) that prebuilt
# engines and exported game builds expect.
#
#   gamedev.enable = true;   # in configuration.nix
#
# Build-time libraries (SDL3, raylib, glfw, Vulkan headers, ...) are not
# installed globally: on NixOS a compiler/pkg-config won't find headers in a
# user profile. Pull them into a per-project `nix develop` shell instead.
#
# Not in nixpkgs, install by hand: Defold, FMOD/Wwise. Unreal Engine has its
# own module (unreal-engine.nix). Unity editors come through Unity Hub.
{ config, lib, options, pkgs, username, ... }:
let
  cfg = config.gamedev;
in
{
  options.gamedev.enable = lib.mkEnableOption "game development tooling";

  config = lib.mkIf cfg.enable {
    # ---- graphics stack ----------------------------------------------
    # 32-bit drivers are needed by Steam/Proton and older engine builds.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # ---- playtesting -------------------------------------------------
    # Steam also installs controller udev rules (hardware.steam-hardware).
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    programs.gamescope.enable = true;
    programs.gamemode.enable = true;

    # Prebuilt editors and exported Linux builds (Unreal, Godot/Unity
    # exports, itch.io downloads) dlopen these at runtime. Appended to
    # nix-ld's default set rather than replacing it.
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries =
      options.programs.nix-ld.libraries.default
      ++ (with pkgs; [
        libGL
        vulkan-loader
        libxkbcommon
        wayland
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
        openal
        udev
        libdrm
        mesa
        fontconfig
        freetype
        dbus
        sdl3
        SDL2
        glib
        gtk3
        nss
        nspr
        icu
        libuuid
      ]);

    users.users.${username}.extraGroups = [ "gamemode" ];

    environment.systemPackages = with pkgs; [
      # ---- engines / frameworks --------------------------------------
      godot                       # GDScript
      godot-mono                  # C# build, binary is godot-mono
      godot-export-templates-bin
      unityhub
      love

      # ---- languages / IDE -------------------------------------------
      dotnet-sdk_8                # Godot C# and Unity scripting
      jetbrains.rider
      emscripten                  # web exports for C/C++ engines
      wasm-pack
      wasm-bindgen-cli
      cargo-generate              # Bevy/Fyrox templates (rustup is in applications.nix)
      mold                        # fast linker for Rust/C++ iteration

      # ---- 3D / 2D art -----------------------------------------------
      blender
      blockbench
      goxel
      meshlab
      material-maker
      gimp
      pixelorama
      libresprite
      # aseprite                  # unfree, not cached: builds Skia from source
      tiled
      ldtk

      # ---- audio -----------------------------------------------------
      audacity
      lmms
      sfxr-qt

      # ---- graphics debugging / profiling ----------------------------
      renderdoc
      tracy
      apitrace
      vulkan-tools                # vulkaninfo, vkcube
      vulkan-validation-layers
      shaderc                     # glslc
      glslang
      spirv-tools
      mesa-demos                  # glxinfo, glxgears
      vkmark
      mangohud
      nvtopPackages.amd
      radeontop
      hotspot
      heaptrack
      perf

      # ---- assets / VCS / capture ------------------------------------
      git-lfs
      ffmpeg
      obs-studio

      # ---- distribution ----------------------------------------------
      butler                      # itch.io uploads
      itch
      steam-run                   # run Steam-runtime builds outside Steam
      wineWow64Packages.stable    # test Windows exports
    ];
  };
}
