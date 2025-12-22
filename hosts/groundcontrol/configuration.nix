{ pkgs, ... }:

{
  config = {
    system.stateVersion = "25.11";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.plymouth.enable = true;

    systemSettings = {
      users = [ "jan" ];
      adminUsers = [ "jan" ];
      powerprofiles = false;
    };

    home-manager.users.jan = {
      home.stateVersion = "25.11";
    };
  };
}
