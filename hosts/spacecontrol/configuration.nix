{ pkgs, ... }:

{
  config = {
    system.stateVersion = "25.11";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.resumeDevice = "/dev/disk/by-uuid/081478af-256a-45ae-98b7-c046acee5fd0";
    boot.plymouth.enable = true;

    networking.networkmanager.wifi.powersave = false;

    systemSettings = {
      users = [ "jan" ];
      adminUsers = [ "jan" ];
      powerprofiles = false;
      displayManager = "gdm";
      windowManager = "gnome";
    };

    home-manager.users.jan = {
      home.stateVersion = "25.11";
      userSettings.windowmanager = "gnome";

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          cursor-theme = "Adwaita";
          cursor-size = 24;
        };
      };
    };

    # Configure systemd to redirect suspend to hibernate
    systemd.sleep.extraConfig = ''
      SuspendMode=
      SuspendState=disk
      HibernateMode=shutdown
      HibernateState=disk
      HybridSleepMode=shutdown
      HybridSleepState=disk
    '';

    # Create systemd service overrides to redirect suspend calls to hibernate
    systemd.services.systemd-suspend = {
      serviceConfig = {
        ExecStart = [
          ""  # Clear the existing ExecStart
          "${pkgs.stdenv.hostPlatform.system}/bin/systemctl hibernate"
        ];
      };
    };

    systemd.services.systemd-hybrid-sleep = {
      serviceConfig = {
        ExecStart = [
          ""  # Clear the existing ExecStart
          "${pkgs.stdenv.hostPlatform.system}/bin/systemctl hibernate"
        ];
      };
    };

    # Configure systemd-logind to hibernate instead of suspend
    services.logind.settings.Login = {
      HandlePowerKey = "hibernate";
      HandlePowerKeyLongPress = "hibernate";
      HandleLidSwitch = "hibernate";
      HandleLidSwitchExternalPower = "hibernate";
      HandleLidSwitchDocked = "ignore";
      HandleSuspendKey = "hibernate";
      HandleSuspendKeyLongPress = "hibernate";
      HandleHibernateKey = "hibernate";
      IdleAction = "hibernate";
      IdleActionSec = "30min";
    };
  };
}
