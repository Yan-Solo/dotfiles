{ config, pkgs, lib, ... }:

let
  displayManager = config.systemSettings.displayManager;
in {
  options = {
    systemSettings.displayManager = lib.mkOption {
      default = "greetd";
      description = "Default displayManager";
      type = lib.types.enum [ "greetd" "gdm" ];
    };
    systemSettings.windowManager = lib.mkOption {
      default = "mangowc";
      description = "Window manager/desktop environment to use";
      type = lib.types.enum [ "mangowc" "gnome" ];
    };
  };

  config = lib.mkMerge [
    # Common configuration for all display managers
    {
      # Ensure Plymouth works with both display managers
      boot.plymouth.enable = lib.mkDefault true;

      # Set windowManager based on displayManager
      systemSettings.windowManager = lib.mkDefault (
        if displayManager == "gdm" then "gnome" else "mangowc"
      );
    }

    # Configuration for greetd + mango
    (lib.mkIf (displayManager == "greetd") {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "tuigreet --time --remember --cmd mango";
            user = "jan";
          };
        };
      };

      # Disable xserver when using greetd + mango (Wayland compositor)
      services.xserver.enable = false;

      environment.systemPackages = with pkgs; [ tuigreet ];
    })

    # Configuration for gdm + gnome
    (lib.mkIf (displayManager == "gdm") {
      services.xserver.enable = true;
      services.displayManager.gdm = {
        enable = true;
        wayland = true;  # Enable Wayland support for GNOME
      };
      services.desktopManager.gnome.enable = true;

      # Enable GNOME services
      services.gnome = {
        gnome-keyring.enable = true;
        # Enable core GNOME services
        core-apps.enable = true;
        core-shell.enable = true;
      };

      # Required services for GDM
      services.dbus.enable = true;
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Disable greetd when using GDM
      services.greetd.enable = false;

      # GNOME environment packages
      environment.systemPackages = with pkgs; [
        gnome-terminal
        nautilus
        gedit
        gnome-tweaks
        gnomeExtensions.appindicator
        adwaita-icon-theme  # Includes cursor themes
        morewaita-icon-theme
      ];

      # Ensure proper cursor theme is available and configured
      environment.variables = {
        XCURSOR_THEME = "Adwaita";
        XCURSOR_SIZE = "24";
      };

      # Configure X11 cursor
      services.xserver.displayManager.sessionCommands = ''
        xsetroot -cursor_name left_ptr
      '';

      # GNOME specific settings
      programs.dconf.enable = true;
      services.udev.packages = with pkgs; [ gnome-settings-daemon ];

      # Optional: Configure GNOME power management
      services.upower.enable = true;
    })
  ];
}
