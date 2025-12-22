{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.zed;
in {
  options = {
    userSettings.zed = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zed editor";
    };
  };

  config = lib.mkIf cfg {
    home.sessionVariables = {
      EDITOR = "zed";
    };

    programs.zed-editor = {
      enable = true;

      extensions = [ "nix" ];

      userSettings = {
        theme = {
          mode = "system";
          dark = "Ayu Dark";
          light = "One Light";
        };

        vim_mode = true;

        base_keymap = "VSCode";
        minimap = {
          max_width_columns = 80;
          thumb = "always";
          show = "always";
        };

        show_whitespaces = "trailing";

        relative_line_numbers = true;

        tab_space = 2;

        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };

      userKeymaps = [
        {
          context = "Terminal";
          bindings = {
            "ctrl-`" = "terminal_panel::ToggleFocus";
          };
        }
      ];
    };
  };
}
