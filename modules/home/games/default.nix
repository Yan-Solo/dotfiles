{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.games;
in {
  options = {
    userSettings.games = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install packages for gaming and some games";
    };
  };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      runelite
    ];
  };
}
