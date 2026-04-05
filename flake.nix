{
  inputs = {
    # get pinned version of nixpkgs. update with `nix flake update nixpkgs` or `nix flake update` for all inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, microvm, ... }@inputs: {
    # configuration name matches hostname, so this system is chosen by default
    nixosConfigurations.metal = nixpkgs.lib.nixosSystem {
      # pass along all the inputs and stuff to the system function
      specialArgs = { inherit inputs; };
      modules = [
        # import configuration
        ./configuration.nix

        inputs.microvm.nixosModules.host

        # home manager part 2
        inputs.home-manager.nixosModules.default

        inputs.nix-index-database.nixosModules.nix-index

        { programs.nix-index-database.comma.enable = true; }
      ];
    };
  };
}
