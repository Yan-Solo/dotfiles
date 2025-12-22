{ config, lib, ... }:

{
  options = {
    systemSettings = {
      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of users to create";
      };
      adminUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of users to grant admin (sudo) access on the system";
      };
    };
  };

  config = {
    users.users = builtins.listToAttrs
      (map (user: {
        name = user;
        value = {
          isNormalUser = true;
          createHome = true;
          extraGroups = [ "networkmanager" ] ++ (lib.optionals (lib.any (x: x == user) config.systemSettings.adminUsers) [ "wheel" ]);
        };
      }) config.systemSettings.users);

    home-manager.users = builtins.listToAttrs
      (map (user: {
        name = user;
        value = {
          home.username = user;
          home.homeDirectory = "/home/${user}";
        };
      }) config.systemSettings.users);
  };
}
