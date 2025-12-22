{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.userSettings.mangowc;
  dotsDir = ./dots;
in {
  options = {
    userSettings.mangowc = {
      enable = lib.mkEnableOption "Enable mangowc windowmanager dotfiles";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.genAttrs
      (builtins.attrNames (builtins.readDir dotsDir))
      (name: {
        target = ".config/${name}";
        source = "${dotsDir}/${name}";
      });
  };
}
