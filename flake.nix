{
  description = "Tonya's NixOS desktop";

  inputs = {

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

    # Zen is not in nixpkgs
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    omp-theme = {
      url = "github:ToneAr/ADAPTIVE-oh-my-posh-theme";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      nix-flatpak,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      hostname = "tonya-nixos";
      username = "tonya";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          nixfmt
          nil
          statix
          deadnix
        ];
      };

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs username; };
        modules = [
          ./system/configuration.nix
          ./system/hardware-configuration.nix
          ./addons/flatpak.nix
          ./addons/wolfram.nix
          ./addons/wolfie.nix

          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # Existing unmanaged files are renamed to *.backup
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs username; };
              # plasma-manager has to be a *home-manager* module
              sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              users.${username} = import ./home/home.nix;
            };
          }
        ];
      };
    };
}
