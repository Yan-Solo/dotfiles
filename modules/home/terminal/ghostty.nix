{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.userSettings.ghostty;
  dotsDir = ./dots;
in {
  options = {
    userSettings.ghostty = {
      enable = lib.mkEnableOption "Enable ghostty terminal emulator";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ghostty
      nerd-fonts.caskaydia-cove
    ];
  };
}
