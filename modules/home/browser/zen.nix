{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.userSettings.zen;
in {
  options = {
    userSettings.zen = {
      enable = lib.mkEnableOption "Set browser env var to zen";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      BROWSER = "zen";
    };
  };
}
