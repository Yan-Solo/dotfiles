{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.userSettings.foot;
  dotsDir = ./dots;
in {
  options = {
    userSettings.foot = {
      enable = lib.mkEnableOption "Enable foot terminal emulator";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      foot
      nerd-fonts.caskaydia-cove
    ];

    home.file = {
      footConfig = {
        source = builtins.path { path = ./dots/foot.ini; };
        target = ".config/foot/foot.ini";
      };
    };
  };
}
