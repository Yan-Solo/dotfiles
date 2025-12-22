{ config, lib, pkgs, ... }:

let
  browser = config.userSettings.browser;
in {
  options = {
    userSettings.browser = lib.mkOption {
      default = "zen";
      description = "Set the default browser env var";
      type = lib.types.enum [ "zen" ];
    };
  };

  config = {
    userSettings.zen.enable = lib.mkIf (browser == "zen") true;
  };
}
