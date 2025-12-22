{ config, lib, ... }:

let
  cfg = config.systemSettings.powerprofiles;
in {
  options = {
    systemSettings.powerprofiles = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable power profiles daemon";
    };
  };

  config = lib.mkIf cfg {
    services.power-profiles-daemon = {
      enable = true;
    };
  };
}
