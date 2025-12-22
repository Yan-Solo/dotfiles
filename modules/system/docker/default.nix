{ config, lib, pkgs, ... }:

let
  cfg = config.systemSettings.docker;
in {
  options = {
    systemSettings.docker = lib.mkOption {
      default = true;
      description = "Enable docker";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg {
    virtualisation.docker = {
      enable = true;
    };

    # Add all system users to the docker group
    users.users = builtins.listToAttrs
      (map (user: {
        name = user;
        value = {
          extraGroups = [ "docker" ];
        };
      }) config.systemSettings.users);
  };
}
