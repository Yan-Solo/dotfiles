{ config, lib, pkgs, inputs, ... }:

let
  displayManager = config.systemSettings.displayManager;
in {
  options = {
    systemSettings.mangowc = lib.mkOption {
      default = "mangowc";
      description = "Enable MangoWC";
      type = lib.types.enum [ "mangowc" ];
    };
  };

  config = lib.mkIf (displayManager == "greetd") {
    environment.systemPackages = with pkgs; [
      quickshell
      xfce.thunar
      wl-clipboard
      phinger-cursors
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.dms-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default
      wdisplays
      xsettingsd
      xorg.xrdb
    ];

    # Enable XDG desktop portal with Hyprland support for screensharing
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.GlobalShortcuts" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
    services.gnome.gnome-keyring.enable = true;
  };
}
