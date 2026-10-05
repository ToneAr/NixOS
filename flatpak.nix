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
      "com.dec05eba.gpu_screen_recorder"
      "com.discordapp.Discord"
      "com.github.IsmaelMartinez.teams_for_linux"
      "com.github.debauchee.barrier"
      "com.github.k4zmu2a.spacecadetpinball"
      "com.github.marhkb.Pods"
      "com.github.marktext.marktext"
      "com.github.paolostivanin.OTPClient"
      "com.jeffser.Alpaca"
      "com.jetpackduba.Gitnuro"
      "com.jgraph.drawio.desktop"
      "com.syntevo.SmartGit"
      "com.thincast.client"
      "dev.ares.ares"
      "dev.mariinkys.Clockode"
      "dev.vieb.Vieb"
      "eu.jumplink.Learn6502"
      "io.github.TheWisker.Cavasik"
      "io.github.alainm23.planify"
      "io.github.giantpinkrobots.flatsweep"
      "io.github.plrigaux.sysd-manager"
      "io.github.pwr_solaar.solaar"
      "io.github.sugarycandybar.Crucible"
      "io.github.ungoogled_software.ungoogled_chromium"
      "io.missioncenter.MissionCenter"
      "io.mrarm.mcpelauncher"
      "me.iepure.devtoolbox"
      "net.mkiol.Jupii"
      "net.pcsx2.PCSX2"
      "org.DolphinEmu.dolphin-emu"
      "org.cosmic_utils.enroll"
      "org.eclipse.Java"
      "org.gnome.baobab"
      "org.inkscape.Inkscape"
      "org.jupyter.JupyterLab"
      "org.kde.iconexplorer"
      "org.kde.krita"
      "org.kde.marknote"
      "org.kde.ruqola"
      "org.onlyoffice.desktopeditors"
      "org.stellarium.Stellarium"
      "org.videolan.VLC"
      "org.wezfurlong.wezterm"
      "uk.co.powdertoy.tpt"
    ];
  };
}
