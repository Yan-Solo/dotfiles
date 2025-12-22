{ config, lib, pkgs, ... }:

let
  cfg = config.systemSettings;
in {
  options = {
    systemSettings = {

      tz = lib.mkOption {
        type = lib.types.str;
        description = "Timezone";
        default = "Europe/Brussels";
      };

      locale = lib.mkOption {
        type = lib.types.str;
        description = "Default system locale";
        default = "en_US.UTF-8";
      };

      extraLocaleSettings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "Extra locale settings";
        default = {
          LC_ADDRESS = "nl_BE.UTF-8";
          LC_IDENTIFICATION = "nl_BE.UTF-8";
          LC_MEASUREMENT = "nl_BE.UTF-8";
          LC_MONETARY = "nl_BE.UTF-8";
          LC_NAME = "nl_BE.UTF-8";
          LC_NUMERIC = "nl_BE.UTF-8";
          LC_PAPER = "nl_BE.UTF-8";
          LC_TELEPHONE = "nl_BE.UTF-8";
          LC_TIME = "nl_BE.UTF-8";
        };
      };
    };
  };

  config = {
    time.timeZone = cfg.tz;
    i18n.defaultLocale = cfg.locale;
    i18n.extraLocaleSettings = cfg.extraLocaleSettings;
  };
}
