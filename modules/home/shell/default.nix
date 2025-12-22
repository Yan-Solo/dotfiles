{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.shell;
in {
  options = {
    userSettings.shell = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable bash with some necessary CLI utilities";
    };
  };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      bash
      btop
      git
      neovim
      starship
      vimPlugins.nvchad
      ripgrep
    ];

    home.file = {
      bashrc = {
        source = builtins.path { path = ./dots/bashrc; };
        target = ".bashrc";
      };
    };

    home.file = {
      starship = {
        source = builtins.path { path = ./dots/starship.toml; };
        target = ".config/starship.toml";
      };
    };
  };
}
