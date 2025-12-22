{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.devops;
  dotsDir = ./dots;
in {
  options = {
    userSettings.devops = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install packages needed for devops work";
    };
  };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      ansible
      git
      go
      jq
      k9s
      kubectl
      kubecolor
      ripgrep
      sshuttle
      terraform
      terragrunt
      yamllint
      yq
    ];

    home.file = lib.genAttrs
      (builtins.attrNames (builtins.readDir dotsDir))
      (name: {
        target = ".config/${name}";
        source = "${dotsDir}/${name}";
      });
  };
}
