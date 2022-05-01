{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-21.11; 
    home-manager = {
      url = github:nix-community/home-manager/release-21.11;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        gianluca = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./hosts/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gianluca = {
                imports = [ ./hosts/home.nix ];
              };
            }
          ];
        };
      };
    };
}
