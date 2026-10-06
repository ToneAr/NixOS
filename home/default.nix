{ username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    ./home-base.nix
    ./dotfiles.nix
    ./plasma
    ./hyprland.nix
  ];

  home.file.".local/share/plasma/plasmoids/org.kde.windowtitle".source =
    ./../assets/org.kde.windowtitle;
  home.file.".config/panel-colorizer/presets".source =
    ./../assets/panel-colorizer-presets;

  home.stateVersion = "26.05";
}
