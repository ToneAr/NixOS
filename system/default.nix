{ username, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
  home-manager.users.${username}.imports = [ ./memory-limits.nix ];
}