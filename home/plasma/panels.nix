# Plasma panels, reconstructed from plasma-org.kde.plasma.desktop-appletsrc
# + plasmashellrc on the Arch box (plasmashell 6.7.5).
#
# rc2nix does NOT read these files, so none of this was generated — it is a
# hand translation. Numeric rc values were decoded against the Q_ENUM metadata
# in /usr/bin/plasmashell:
#   location        3 = top, 6 = right   (Plasma::Types::Location)
#   panelVisibility 0 = NormalPanel, 1 = AutoHide, 2 = DodgeWindows, 3 = WindowsGoBelow
#   panelOpacity    0 = Adaptive, 1 = Opaque, 2 = Translucent
#   panelLengthMode 0 = FillAvailable, 1 = FitContent, 2 = Custom
#   alignment       Qt::Alignment bitmask: 132 = 0x84 = HCenter|VCenter, 2 = AlignRight
#
# HEADS UP, read before rebuilding:
#
# 1. This was a FOUR-SCREEN setup (the DisplayLink dock). Panels are pinned to
#    screens 0-3. On a machine with fewer outputs, Plasma stacks the orphans
#    onto screen 0 and you get a pile of top panels. Comment out the panels for
#    screens you do not have — they are marked below.
#
# 2. plasma-manager DELETES plasma-org.kde.plasma.desktop-appletsrc on every
#    activation (upstream issue #76) and rebuilds it from this file. Anything
#    you tweak in the GUI is gone on next rebuild. Panels are all-or-nothing:
#    once this option is set, this file is the only source of truth.
#
# 3. Panel Colorizer styling is NOT here. Its settings are a single 53KB
#    (88KB on the folder panels) JSON blob in globalSettings, keyed by applet
#    IDs that change every time plasma-manager recreates the panels — so
#    inlining it would be both enormous and wrong. Instead: ship the presets
#    directory and apply the preset once by hand. See the note at the bottom.
{ lib, ... }:
let
  # Panels for screens 1-3 only make sense on the 4-screen DisplayLink dock,
  # which this config does not drive (see configuration.nix). Left off, the
  # single laptop screen gets only the screen-0 panels instead of a pile of
  # orphaned ones. Set to true if you enable DisplayLink.
  dockScreens = false;
in
{
  programs.plasma.panels = [

    # ================================================================
    # Screen 0 — the main top panel (rc: Containment 254)
    # ================================================================
    {
      location = "top";
      screen = 0;
      height = 38;
      floating = false;
      lengthMode = "fill";
      hiding = "normalpanel";
      widgets = [
        {
          name = "org.kde.plasma.kickoff";
          config.General = {
            compactMode = true;
            icon = "kubuntu";
            primaryActions = 1;
            systemFavorites = "lock-screen,logout,save-session,switch-user";
          };
        }
        {
          name = "org.kde.plasma.pager";
          config.General.displayedText = "Number";
        }
        # Third-party widget, not in nixpkgs; linked from assets/ in home.nix.
        {
          name = "org.kde.windowtitle";
          config.General.filterActivityInfo = false;
        }
        "org.kde.plasma.appmenu"
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            groupedTaskVisualization = 1;
            highlightWindows = true;
            middleClickAction = "Close";
            showOnlyCurrentScreen = true;
            launchers = [
              "applications:org.kde.dolphin.desktop"
              "applications:org.gnome.Evolution.desktop"
              "applications:org.kde.kmail2.desktop"
              "applications:md.obsidian.Obsidian.desktop"
            ];
          };
        }
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.systemmonitor.cpucore";
          config = {
            Appearance = {
              chartFace = "org.kde.ksysguard.barchart180";
              title = "CPU Usage";
            };
            Sensors = {
              highPrioritySensorIds = ''["cpu/cpu.*/usage"]'';
              totalSensors = ''["cpu/all/usage"]'';
            };
            # The old box had 16 per-core entries all set to white; only the
            # aggregate colour is meaningful and core count will differ anyway.
            SensorColors."cpu/cpu.*/usage" = "15,124,124";
            "org.kde.ksysguard.barchart/General" = {
              rangeAuto = false;
              showYAxisLabels = false;
            };
          };
        }
        {
          name = "org.kde.plasma.systemmonitor.memory";
          config = {
            Appearance = {
              chartFace = "org.kde.ksysguard.piechartclean";
              showTitle = true;
              title = "Memory Usage";
            };
            Sensors = {
              highPrioritySensorIds = ''["memory/physical/used"]'';
              lowPrioritySensorIds = ''["memory/physical/total"]'';
              totalSensors = ''["memory/physical/usedPercent"]'';
            };
            SensorColors."memory/physical/used" = "255,255,255";
            "org.kde.ksysguard.piechartclean/General" = {
              fromAngle = 0;
              toAngle = 360;
              smoothEnds = false;
            };
          };
        }
        "org.kde.plasma.systemtray"
        {
          name = "org.kde.plasma.digitalclock";
          config.Appearance = {
            autoFontAndSize = false;
            dateFormat = "custom";
            customDateFormat = "ddd - dd/MM/yyyy ";
            fontFamily = "Space Grotesk Medium";
            fontSize = 14;
            fontStyleName = "Regular";
            fontWeight = 500;
            showSeconds = 2;
          };
        }
        # pkgs.plasma-panel-colorizer is pulled in automatically by
        # plasma-manager when this widget name appears.
        {
          name = "luisbocanegra.panel.colorizer";
          config.General.hideWidget = true;
        }
        "org.kde.plasma.notifications"
        "org.kde.plasma.minimizeall"
      ];
    }

    # ================================================================
    # Screen 0 — floating folder panel, right edge (rc: Containment 407)
    # A "desklet"-style autohiding strip showing ~/Working
    # ================================================================
    {
      location = "right";
      screen = 0;
      height = 250;          # thickness, for a vertical panel
      floating = true;
      alignment = "right";
      lengthMode = "custom";
      minLength = 260;
      maxLength = 260;
      offset = 322;
      opacity = "translucent";
      hiding = "autohide";
      widgets = [
        {
          name = "org.kde.plasma.folder";
          config.General = {
            url = "file:///home/tonya/Working";
            showHiddenFiles = true;
            sortMode = -1;
          };
        }
        {
          name = "luisbocanegra.panel.colorizer";
          config.General.hideWidget = true;
        }
      ];
    }

  ] ++ lib.optionals dockScreens [
    # ================================================================
    # DOCK SCREENS 1-3. All three are the same slim top panel; 437 adds a
    # window list.
    # ================================================================
    {
      location = "top";
      screen = 1;                     # rc: Containment 290
      height = 37;
      floating = false;
      alignment = "center";
      hiding = "normalpanel";
      widgets = [
        "org.kde.plasma.appmenu"
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            middleClickAction = "Close";
            showOnlyCurrentScreen = true;
          };
        }
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.digitalclock";
          config.Appearance = {
            autoFontAndSize = false;
            dateFormat = "custom";
            customDateFormat = "ddd - dd/MM/yyyy ";
            fontFamily = "Space Grotesk Medium";
            fontSize = 12;
            fontStyleName = "Regular";
            fontWeight = 500;
            showSeconds = 2;
          };
        }
        {
          name = "luisbocanegra.panel.colorizer";
          config.General.hideWidget = true;
        }
      ];
    }

    {
      location = "top";
      screen = 2;                     # rc: Containment 437
      height = 37;
      floating = false;
      alignment = "center";
      hiding = "normalpanel";
      widgets = [
        "org.kde.plasma.windowlist"
        "org.kde.plasma.appmenu"
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            middleClickAction = "Close";
            showOnlyCurrentScreen = true;
          };
        }
        "org.kde.plasma.panelspacer"
        {
          name = "luisbocanegra.panel.colorizer";
          config.General.hideWidget = true;
        }
        {
          name = "org.kde.plasma.digitalclock";
          config.Appearance = {
            autoFontAndSize = false;
            dateFormat = "custom";
            customDateFormat = "ddd - dd/MM/yyyy ";
            fontFamily = "Space Grotesk Medium";
            fontSize = 12;
            fontStyleName = "Regular";
            fontWeight = 500;
            showSeconds = 2;
          };
        }
      ];
    }

    {
      location = "top";
      screen = 3;                     # rc: Containment 497
      height = 37;
      floating = false;
      alignment = "center";
      hiding = "normalpanel";
      widgets = [
        "org.kde.plasma.appmenu"
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            middleClickAction = "Close";
            showOnlyCurrentScreen = true;
          };
        }
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.digitalclock";
          config.Appearance = {
            autoFontAndSize = false;
            dateFormat = "custom";
            customDateFormat = "ddd - dd/MM/yyyy ";
            fontFamily = "Space Grotesk Medium";
            fontSize = 12;
            fontStyleName = "Regular";
            fontWeight = 500;
            showSeconds = 2;
          };
        }
        {
          name = "luisbocanegra.panel.colorizer";
          config.General.hideWidget = true;
        }
      ];
    }
  ];

  # Panel Colorizer presets. These are what actually carry your panel styling;
  # the widget reads them from this path. After the first rebuild, open each
  # colorizer widget once and load the preset ("separated" for the top panels,
  # "separated WIP" for the folder panel).
  #
  # The presets are linked from assets/panel-colorizer-presets in home.nix:
  # "blurred rounded", "separated", "separated WIP", "side panel".
}
