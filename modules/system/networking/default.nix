{ config, lib, pkgs, ... }:

let
  cfg = config.systemSettings.networking;
in {
  options = {
    systemSettings.networking = {
      enable = lib.mkOption {
        default = true;
        description = "Enable networking";
        type = lib.types.bool;
      };

      tailScale = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable tailScale";
      };

      bluetooth = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Bluetooth";
      };
    };
  };

  config = {
    networking.networkmanager.enable = cfg.enable;
    services.tailscale.enable = cfg.tailScale;
    hardware.bluetooth.enable = cfg.bluetooth;
  };
}
