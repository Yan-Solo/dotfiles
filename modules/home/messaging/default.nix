{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.messaging;
in {
  options = {
    userSettings.messaging = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable messaging apps";
    };
  };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      caprine
      discord
      signal-desktop
      zapzap
    ];
  };
}
