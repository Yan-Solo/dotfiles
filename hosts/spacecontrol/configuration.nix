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

    # Disable broken sleep and configure hibernate on lid close/power button
    services.logind.settings.Login = {
      HandleLidSwitchDocked = "hibernate";
      HandleLidSwitchExternalPower = "hibernate";
      HandleLidSwitch = "hibernate";
      HandleHibernateKey = "hibernate";
      HandleSuspendKey = "hibernate";
      HandlePowerKey = "hibernate";
    };

    # Disable sleep entirely (use hibernate instead)
    systemd.sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=yes
      AllowSuspendThenHibernate=no
      AllowHybridSleep=no
    '';

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
  };
}
