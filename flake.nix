{
  description = "New NixOS Config.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
    inherit (self) outputs;
  in {
    # NixOS configuration entry point.
    # To rebuild, use "nixos-rebuild --flake .#hostname"
    nixosConfigurations = {
      grapefruit = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
	  ./systems/grapefruit.nix
	  ./systems/hw/grapefruit.nix
          home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.alto = import ./hm/alto.nix;
	  }
        ];
      };
    };
  };
}
