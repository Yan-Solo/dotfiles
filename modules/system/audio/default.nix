{ config, lib, pkgs, ... }:

let
  cfg = config.systemSettings.audio;
in {
  options = {
    systemSettings.audio.pipewire = lib.mkOption {
      default = true;
      description = "Enable pipewire";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.pipewire {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
