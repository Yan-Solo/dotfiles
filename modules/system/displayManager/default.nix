{ config, pkgs, lib, ... }:

let
  displayManager = config.systemSettings.displayManager;
in {
  options = {
    systemSettings.displayManager = lib.mkOption {
      default = "greetd";
      description = "Default displayManager";
      type = lib.types.enum [ "greetd" ];
    };
  };

  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "tuigreet --time --remember --cmd mango";
          user = "jan";
        };
      };
    };

    environment.systemPackages = with pkgs; [ tuigreet ];
  };
}
