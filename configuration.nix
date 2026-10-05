{ config, pkgs, username, ... }:
{
  # ---- boot ----------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Kernel: left on the nixpkgs default (LTS). Arch runs mainline; switch with
  #   boot.kernelPackages = pkgs.linuxPackages_latest;
  # if you need newer amdgpu, at the cost of out-of-tree modules (xone) lagging.

  # From /etc/modprobe.d on Arch: nested virtualisation for libvirt guests.
  boot.extraModprobeConfig = "options kvm_amd nested=1";

  # From /etc/sysctl.d on Arch (editors/LSPs watching big trees).
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 557056;

  # ---- basics --------------------------------------------------------
  networking.hostName = "tonya-nixos";   # keep in sync with flake.nix
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_US.UTF-8";   # matches /etc/locale.conf on Arch

  # Extra /etc/hosts entries carried over from Arch.
  networking.hosts."127.0.0.1" = [ "kubernetes.docker.internal" ];

  hardware.cpu.amd.updateMicrocode = true;   # AuthenticAMD, per the old box
  hardware.enableRedistributableFirmware = true;

  # ---- user ----------------------------------------------------------
  users.users.${username} = {
    isNormalUser = true;
    description = "Antonis Aristeidou";
    extraGroups = [
      "wheel" "networkmanager" "video" "audio" "input"
      "docker" "libvirtd" "kvm" "uinput"
    ];
    shell = pkgs.fish;
    # sshd below is key-only. Add your public keys here, e.g.
    #   openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA... tonya@laptop" ];
  };

  # ---- Plasma 6 ------------------------------------------------------
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Hyprland as a second session choice at the SDDM greeter. The system-level
  # option installs the session entry and xdg-desktop-portal-hyprland; the
  # home-manager module in hyprland.nix writes the config.
  programs.hyprland.enable = true;

  # Keyboard layout: Plasma on Arch (kxkbrc) and Hyprland both use plain US.
  services.xserver.xkb.layout = "us";

  # ---- audio ---------------------------------------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ---- hardware services (enabled on Arch) ----------------------------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Synaptics 06cb:00f9 works with stock libfprint, no TOD driver needed.
  # The module also turns on fingerprint auth in PAM (login, sddm, sudo).
  services.fprintd.enable = true;

  # Xbox wireless adapter (xone-dkms + xone-dongle-firmware on Arch).
  hardware.xone.enable = true;

  # power-profiles-daemon is already enabled by the Plasma 6 module, which
  # matches Arch (TLP is installed there but masked).

  # DisplayLink dock: NOT enabled. It needs the unfree driver zip fetched by
  # hand (nix-prefetch-url --name displaylink-*.zip ...) and the dock's NIC
  # flaps anyway. When wanted:
  #   services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # ---- networked services --------------------------------------------
  # NixOS has a firewall on by default (Arch had none); each service below
  # opens only the ports it needs.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Installs KDE Connect and opens 1714-1764 tcp/udp.
  programs.kdeconnect.enable = true;

  # Weylus (weylus-bin on Arch): uinput access + its port.
  programs.weylus = {
    enable = true;
    users = [ username ];
    openFirewall = true;
  };
  hardware.uinput.enable = true;

  security.apparmor.enable = true;

  # ---- memory: swap + oomd -------------------------------------------
  # The portable drive has no swap partition; zram stands in for the 64G
  # swap on Arch so oomd's swap-kill policy has something to act on.
  zramSwap.enable = true;

  # Same policy as Arch's -.slice.d/oomd.conf and user@.service.d/oomd.conf.
  systemd.oomd.enable = true;
  systemd.slices."-".sliceConfig.ManagedOOMSwap = "kill";
  systemd.services."user@".serviceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "50%";
  };

  # ---- theme packages the Plasma config references --------------------
  # Without these, Plasma silently falls back to Breeze.
  environment.systemPackages = with pkgs; [
    klassy
    darkly
  ];

  fonts.packages = with pkgs; [
    # Space Grotesk, which panels.nix/plasma.nix set as the clock font.
    # Selective build: pulling all of google-fonts is several GB.
    (google-fonts.override { fonts = [ "Space Grotesk" ]; })

    # Nerd Fonts installed on Arch. JetBrainsMono is the Plasma fixed font
    # and ghostty font, 0xProto is Spectacle's annotation font, and
    # oh-my-posh needs the symbols.
    nerd-fonts.jetbrains-mono
    nerd-fonts._0xproto
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.mononoki
    nerd-fonts.blex-mono
    nerd-fonts.anonymice
    nerd-fonts.symbols-only
    jetbrains-mono
  ];

  # Required for pkgs.fish as a login shell: registers it in /etc/shells and
  # installs vendor completions for system packages.
  programs.fish.enable = true;

  # ---- containers / VMs ----------------------------------------------
  virtualisation.docker.enable = true;

  # Arch had the rootless podman.socket enabled per user.
  virtualisation.podman.enable = true;
  systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Wolfram/Mathematica integration (env vars, kernel pool services, desktop
  # entry, Ctrl+Alt+M, criu, hosts pins). Off: no longer needed day to day.
  # Install Wolfram into ~/Wolfram/Wolfram/<version> first, then flip this.
  wolfram.enable = false;
  # wolfram.version = "15.1";

  # wolfie CLI, fetched by its curl bootstrap script into ~/.local/bin.
  # Needs a Wolfram kernel at runtime (wolfram.enable above, or one on PATH).
  wolfie.enable = true;
  # wolfie.version = "v0.9.20b";   # pin a release; default is "latest"

  # Lets prebuilt, non-Nix binaries (installers, downloaded CLIs) find a
  # dynamic linker and common libraries.
  programs.nix-ld.enable = true;

  # config.fish raised this per-shell with `ulimit -n 65536`; done properly here.
  security.pam.loginLimits = [
    { domain = username; type = "soft"; item = "nofile"; value = "65536"; }
  ];

  # Several apps in applications.nix are unfree: google-chrome, vscode,
  # obsidian, zoom-us, gitkraken, wpsoffice, rocketchat-desktop.
  # Swap to allowUnfreePredicate if you would rather whitelist explicitly.
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set this to the NixOS release you installed from. Do NOT bump it
  # casually; it controls stateful-data compatibility.
  system.stateVersion = "26.05";
}
