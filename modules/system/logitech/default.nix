{ config, lib, pkgs, ... }:

let
  cfg = config.systemSettings.logitech;
in {
  options = {
    systemSettings.logitech = lib.mkOption {
      default = true;
      description = "Enable logitech peripherals such as my mouse";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg {
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
    ];
    boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  };
}
