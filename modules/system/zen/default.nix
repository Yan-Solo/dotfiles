{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.systemSettings.zen;
in {
  options = {
    systemSettings.zen = lib.mkOption {
      default = true;
      description = "Enable Zen Browser";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg {
    environment.systemPackages = with pkgs; [
      (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default)
      (chromium.override { enableWideVine = true; })
    ];
  };
}
