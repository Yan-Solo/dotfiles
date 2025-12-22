{
  description = "Jansan's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Get specific devices hardware extras
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-cli = {
      url = "github:AvengeMedia/danklinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
      inputs.dms-cli.follows = "dms-cli";
    };

    matugen = {
       url = "github:/InioX/Matugen";
       inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
        url = "github:0xc000022070/zen-browser-flake";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }:
  let
    system = "x86_64-linux";
    lib = inputs.nixpkgs.lib;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # create a list of all directories inside of ./hosts
    # every directory in ./hosts has config for that machine
    hosts = builtins.filter (x: x != null) (lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (builtins.readDir ./hosts));
  in {
    nixosConfigurations = builtins.listToAttrs
      (map (host: {
        name = host;
        value = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # host specific config
            { config.networking.hostName = host; }
            (./hosts + "/${host}")
            # (inputs.secrets.hostSecrets.${host})

            # my modules
            ./modules/system

            # Configure nixpkgs
            {
              nixpkgs.pkgs = pkgs;
            }

            # home manager
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ] ++ (if host == "spacecontrol" then [ inputs.nixos-hardware.nixosModules.hp-elitebook-845g7 ] else []);
          specialArgs = {
            inherit inputs;
            nixos-hardware = inputs.nixos-hardware;
          };
        };
      }) hosts);
  };
}
