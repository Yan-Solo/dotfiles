{ config, lib, pkgs, ...}:

let
  cfg = config.userSettings.media;
in {
  options = {
    userSettings.media = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable media and streaming applications";
    };
  };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      jellyfin-web
      spotify
      vlc
    ];
  };
}
