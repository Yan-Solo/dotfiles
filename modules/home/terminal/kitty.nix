{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.kitty;
in {
  options = {
    userSettings.kitty = {
      enable = lib.mkEnableOption "Enable kitty terminal emulator";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
    ];
  };
}
