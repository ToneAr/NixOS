# Plasma configuration, generated from Arch (plasmashell 6.7.5) via
#   nix run github:nix-community/plasma-manager#rc2nix
# then pruned by hand.
#
# Import into home-manager:
#   imports = [ inputs.plasma-manager.homeModules.plasma-manager ./plasma.nix ];
{ ... }:
{
  imports = [
    ./panels.nix
    ./desktop-effects.nix
    ./shortcuts.nix
    ./window-rules.nix
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "KlassyDarkGlass";
      widgetStyle = "Klassy";
      theme = "klassy-dark-glass";
      iconTheme = "YAMIS";
      cursor.theme = "BreezeX-Dark";
      windowDecorations = {
        library = "org.kde.klassy";
        theme = "Klassy";
      };
    };

    

    configFile = {
      ## Locale
      kxkbrc.Layout.LayoutList = "us";
      kxkbrc.Layout.Use = true;
      plasma-localerc.Formats.LANG = "en_GB.UTF-8";
    
      ## Default Applications
      kdeglobals.General.BrowserApplication = "zen-browser.desktop";
      kdeglobals.General.TerminalApplication = "kitty";
      kdeglobals.General.TerminalService = "kitty.desktop";

      ## Virtual Desktops
      kwinrc.Desktops.Name_1 = "I";
      kwinrc.Desktops.Name_10 = "X";
      kwinrc.Desktops.Name_2 = "II";
      kwinrc.Desktops.Name_3 = "III";
      kwinrc.Desktops.Name_4 = "IV";
      kwinrc.Desktops.Name_5 = "V";
      kwinrc.Desktops.Name_6 = "VI";
      kwinrc.Desktops.Name_7 = "VII";
      kwinrc.Desktops.Name_8 = "VIII";
      kwinrc.Desktops.Name_9 = "IX";
      kwinrc.Desktops.Number = 10;
      kwinrc.Desktops.Rows = 2;
      kwinrc.TabBox.MultiScreenMode = 1;
      kwinrc.TabBoxAlternative.LayoutName = "sidebar";
      kwinrc.Windows.BorderlessMaximizedWindows = false;

      ## Notifications
      plasmanotifyrc.Notifications.PopupPosition = "BottomRight";
      plasmaparc.General.RaiseMaximumVolume = true;
      plasmaparc.General.VolumeStep = 2;

      ## Mouse Settings
      kcminputrc.Mouse.X11LibInputXAccelProfileFlat = true;
      kcminputrc.Mouse.XLbInptAccelProfileFlat = true;
      kcminputrc.Mouse.XLbInptMiddleEmulation = false;
      kcminputrc.Mouse.XLbInptNaturalScroll = false;
      kcminputrc.Mouse.XLbInptPointerAcceleration = "-0.6";

      ## System Settings
      kdeglobals.General.UseSystemBell = true;
      kdeglobals.General.XftAntialias = true;
      kdeglobals.General.XftHintStyle = "hintslight";
      kdeglobals.General.XftSubPixel = "vrgb";
      kdeglobals.General.accentColorFromWallpaper = true;

      ## Fonts
      kdeglobals.General.fixed = "JetBrainsMono Nerd Font Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.font = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.menuFont = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.smallestReadableFont = "Ubuntu,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.toolBarFont = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.WM.activeFont = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";

      ## Appearance
      kdeglobals.KDE.AnimationDurationFactor = 0.5;
      kdeglobals.KDE.contrast = 4;
      kdeglobals.KDE.frameContrast = 0.2;

      ## KRunner
      krunnerrc.General.FreeFloating = true;
      krunnerrc.General.historyBehavior = "ImmediateCompletion";
      krunnerrc.PlasmaRunnerManager.migrated = true;
      krunnerrc.Plugins.baloosearchEnabled = true;
  
      ## Screen Locker
      kscreenlockerrc.Daemon.LockGrace = 30;
      kscreenlockerrc.Daemon.Timeout = 15;
      kscreenlockerrc.Greeter.WallpaperPlugin = "org.kde.potd";

      ## KWallet
      kwalletrc.Wallet.Enabled = true;
      kwalletrc.Wallet."Close When Idle" = false;
      kwalletrc.Wallet."Close on Screensaver" = false;
      kwalletrc.Wallet."First Use" = false;
      kwalletrc.Wallet."Idle Timeout" = 10;
      kwalletrc.Wallet."Launch Manager" = true;
      kwalletrc.Wallet."Leave Manager Open" = false;
      kwalletrc.Wallet."Leave Open" = true;
      kwalletrc.Wallet."Prompt on Open" = false;
      kwalletrc.Wallet."Use One Wallet" = true;
      kwalletrc."org.freedesktop.secrets".apiEnabled = true;
  
      ## Disable baloo indexing
      baloofilerc."Basic Settings".Indexing-Enabled = false;
      
      ## Dolphin 
      dolphinrc.CompactMode.PreviewSize = 16;
      dolphinrc.ContextMenu.ShowCopyMoveMenu = true;
      dolphinrc.DetailsMode.PreviewSize = 16;
      dolphinrc.General.AutoExpandFolders = true;
      dolphinrc.General.BrowseThroughArchives = true;
      dolphinrc.General.MenuBar = "Disabled";
      dolphinrc.General.OpenExternallyCalledFolderInNewTab = true;
      dolphinrc.InformationPanel.previewsAutoPlay = true;
      dolphinrc.InformationPanel.showHovered = false;
      dolphinrc."KFileDialog Settings"."Places Icons Auto-resize" = true;
      dolphinrc."KFileDialog Settings"."Places Icons Static Size" = 16;
      dolphinrc."MainWindow/Toolbar mainToolBar".ToolButtonStyle = "IconOnly";
      dolphinrc.PlacesPanel.IconSize = "-1";
      dolphinrc.PreviewSettings.Plugins = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
      dolphinrc.VersionControl.enabledPlugins = "Git";
    };
  };
}
