modules: {
  user =
    username:
    {
      admin ? false,
      desktop ? null,
    }:
    {
      nixos.${username} = { lib, pkgs, ... }: {
        users.users.${username} = {
          isNormalUser = true;
          home = "/home/${username}";
          extraGroups = lib.optionals admin [ "wheel" ];
          shell = pkgs.zsh;
        };
        programs.zsh.enable = true;

        zix.desktops = lib.optional (desktop != null) desktop;

        home-manager.users.${username} = {
          imports = [ modules.homeManager.${username} ];
        };
      };

      darwin.${username} = { lib, pkgs, ... }: {
        users.users.${username} = {
          home = "/Users/${username}";
          shell = pkgs.zsh;
        };
        programs.zsh.enable = true;

        home-manager.users.${username} = {
          imports = [ modules.homeManager.${username} ];
        };

        system.primaryUser = lib.mkIf admin username;
      };

      homeManager.${username} = { lib, ... }: {
        imports = lib.optional (desktop != null) modules.homeManager.${desktop};

        home.username = username;
      };
    };
}
