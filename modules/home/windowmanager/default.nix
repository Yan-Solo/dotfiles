{ config, lib, pkgs, ... }:

let
  windowmanager = config.userSettings.windowmanager;
in {
  options = {
    userSettings.windowmanager = lib.mkOption {
      default = "mangowc";
      description = "Window manager to deploy";
      type = lib.types.enum [ "mangowc" ];
    };
  };

  config = {
    userSettings.mangowc.enable = lib.mkIf (windowmanager == "mangowc") true;
  };
}
