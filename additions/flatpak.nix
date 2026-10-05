# Flatpak apps installed on the Arch box (`flatpak list --app`), installed
# declaratively by nix-flatpak. Installs run in a systemd service after boot,
# so the first boot with network pulls them in the background.
{ ... }:
{
  services.flatpak = {
    enable = true;
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
    update.onActivation = false;
    packages = [
      "com.github.IsmaelMartinez.teams_for_linux"
      "com.github.debauchee.barrier"
      "com.jgraph.drawio.desktop"
      "com.thincast.client"
      "dev.vieb.Vieb"
      "io.github.TheWisker.Cavasik"
      "io.github.plrigaux.sysd-manager"
      "io.github.pwr_solaar.solaar"
      "net.pcsx2.PCSX2"
      "org.DolphinEmu.dolphin-emu"
      "org.cosmic_utils.enroll"
      "org.eclipse.Java"
      "org.inkscape.Inkscape"
      "org.jupyter.JupyterLab"
      "org.kde.iconexplorer"
      "org.kde.krita"
      "org.onlyoffice.desktopeditors"
      "org.stellarium.Stellarium"
      "org.wezfurlong.wezterm"
    ];
  };
}
