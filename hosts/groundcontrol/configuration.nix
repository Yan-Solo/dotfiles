{ pkgs, ... }:

{
  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.11";

    home-manager.users.jan = {
      home.stateVersion = "25.11";
    };
  };
}
