{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.dev;
  dotsDir = ./dots;
in {
  options = {
    userSettings.dev = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install packages needed for development work";
    };
  };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      git
      go
      jq
      nodejs_24
      obsidian
      pnpm_9
      ripgrep
      yamllint
      yq
    ];
  };
}
