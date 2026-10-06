{ ... }:
{
  programs.plasma = {
    configFile = {
      kwinrulesrc.General.rules = "kitty,inkscape,remmina,konsole,evolution-notify,opaque,opacity";
      
      kwinrulesrc.opacity.Description = "Opacity";
      kwinrulesrc.opacity.opacityactive = 84;
      kwinrulesrc.opacity.opacityactiverule = 2;
      kwinrulesrc.opacity.opacityinactive = 84;
      kwinrulesrc.opacity.opacityinactiverule = 2;
      kwinrulesrc.opacity.wmclasscomplete = true;

      kwinrulesrc.opaque.Description = "Opaque";
      kwinrulesrc.opaque.opacityactive = 100;
      kwinrulesrc.opaque.opacityactiverule = 2;
      kwinrulesrc.opaque.opacityinactive = 100;
      kwinrulesrc.opaque.opacityinactiverule = 2;
      kwinrulesrc.opaque.wmclasscomplete = true;
      kwinrulesrc.opaque.title = "(Picture-in-Picture)|(.* - Youtube.*)";
      kwinrulesrc.opaque.titlematch = 3;

      kwinrulesrc.kitty.Description = "Kitty";
      kwinrulesrc.kitty.opacityactiverule = 2;
      kwinrulesrc.kitty.opacityinactiverule = 2;
      kwinrulesrc.kitty.wmclass = "kitty kitty";
      kwinrulesrc.kitty.wmclasscomplete = true;
      kwinrulesrc.kitty.wmclassmatch = 1;

      kwinrulesrc.konsole.Description = "Konsole";
      kwinrulesrc.konsole.opacityactiverule = 2;
      kwinrulesrc.konsole.opacityinactiverule = 2;
      kwinrulesrc.konsole.wmclass = "konsole org.kde.konsole";
      kwinrulesrc.konsole.wmclasscomplete = true;
      kwinrulesrc.konsole.wmclassmatch = 1;
  
      kwinrulesrc.evolution-notify.Description = "Evolution notify";
      kwinrulesrc.evolution-notify.above = true;
      kwinrulesrc.evolution-notify.aboverule = 2;
      kwinrulesrc.evolution-notify.desktops = "\\0";
      kwinrulesrc.evolution-notify.desktopsrule = 2;
      kwinrulesrc.evolution-notify.wmclass = "evolution-alarm-notify evolution-alarm-notify";
      kwinrulesrc.evolution-notify.wmclasscomplete = true;
      kwinrulesrc.evolution-notify.wmclassmatch = 1;

      kwinrulesrc.inkscape.Description = "Inkscape";
      kwinrulesrc.inkscape.opacityactiverule = 2;
      kwinrulesrc.inkscape.opacityinactiverule = 2;
      kwinrulesrc.inkscape.types = 1;
      kwinrulesrc.inkscape.wmclass = "org.inkscape.Inkscape";
      kwinrulesrc.inkscape.wmclasscomplete = true;
      kwinrulesrc.inkscape.wmclassmatch = 1;

      kwinrulesrc.remmina.Description = "Remmina";
      kwinrulesrc.remmina.opacityactiverule = 2;
      kwinrulesrc.remmina.opacityinactiverule = 2;
      kwinrulesrc.remmina.types = 1;
      kwinrulesrc.remmina.wmclass = "remmina org.remmina.Remmina";
      kwinrulesrc.remmina.wmclasscomplete = true;
      kwinrulesrc.remmina.wmclassmatch = 1;
    };
  };
}