{
  description = "Tonya's NixOS desktop";

  inputs = {
    # Rolling, to match the Plasma 6.7.5 that wrote the configs in plasma.nix.
    # Swap to "github:NixOS/nixpkgs/nixos-26.05" for the stable channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Zen is not in nixpkgs (zen-browser-bin from the AUR on Arch).
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Declarative Flatpak installs (the Arch box had 44 Flathub apps).
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, nix-flatpak, ... }@inputs:
    let
      system = "x86_64-linux";
      hostname = "tonya-nixos";
      username = "tonya";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs username; };
        modules = [
          ./configuration.nix
          ./system/hardware-configuration.nix
          ./additions/flatpak.nix
          ./additions/wolfram.nix
          ./additions/wolfie.nix

          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # Existing unmanaged files are renamed to *.backup instead of
              # failing activation.
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs username; };
              # plasma-manager has to be a *home-manager* module, so it is
              # imported here rather than in the NixOS module list above.
              sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              users.${username} = import ./home.nix;
            };
          }
        ];
      };
    };
}
