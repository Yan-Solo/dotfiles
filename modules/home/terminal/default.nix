{ config, lib, pkgs, ... }:

let
  terminal = config.userSettings.terminal;
in {
  options = {
    userSettings.terminal = lib.mkOption {
      default = "foot";
      description = "Default terminal emulator";
      type = lib.types.enum [ "foot" "kitty" "ghostty" ];
    };
  };

  config = {
    userSettings.foot.enable = lib.mkIf (terminal == "foot") true;
    userSettings.kitty.enable = lib.mkIf (terminal == "kitty") true;
    userSettings.ghostty.enable = lib.mkIf (terminal == "ghostty") true;
  };
}
