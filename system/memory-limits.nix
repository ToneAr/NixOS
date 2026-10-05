# Per-user memory limits carried over from ~/.config/systemd/user on Arch.
#
# The runaway kwin_wayland growth on Arch turned out to be the Better Blur
# (dx) KWin effect, which this config does not install. The caps stay as a
# safety net so a leak takes down one app instead of the whole session. The
# Arch kwin-zen-watchdog script is not ported; with Better Blur gone it has
# nothing to watch for.
{ inputs, pkgs, ... }:
let
  zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Same as ~/.local/bin/zen-browser on Arch: run Zen inside zen.slice.
  zen-in-slice = pkgs.writeShellScriptBin "zen-browser" ''
    exec systemd-run --user --slice=zen.slice --scope --quiet -- ${zen}/bin/zen-beta "$@"
  '';
in
{
  home.packages = [ zen zen-in-slice ];

  systemd.user.slices.zen = {
    Unit.Description = "Resource-capped slice for Zen Browser";
    Slice = {
      MemoryAccounting = true;
      MemoryHigh = "28G";   # soft cap: reclaim pressure starts here
      MemoryMax = "30G";    # hard cap: cgroup OOM kills a Zen process
      MemorySwapMax = "8G";
    };
  };

  # Drop-in only; a full systemd.user.services entry would replace Plasma's
  # own unit.
  xdg.configFile."systemd/user/plasma-kwin_wayland.service.d/memcap.conf".text = ''
    [Service]
    MemoryMax=50G
    MemorySwapMax=2G
  '';
}
