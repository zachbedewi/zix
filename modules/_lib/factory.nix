modules: {
  user =
    username:
    {
      admin ? false,
      sshPublicKey ? null,
    }:
    {
      nixos.${username} = { lib, pkgs, ... }: {
        users.users.${username} = {
          isNormalUser = true;
          home = "/home/${username}";
          extraGroups = lib.optionals admin [ "wheel" ] ++ lib.optionals (sshPublicKey != null) [ "sshusers" ];
          shell = pkgs.zsh;
        };
        programs.zsh.enable = true;

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

      homeManager.${username} = {
        home.username = username;
        imports = [ modules.homeManager.ssh ];
        zix.ssh.publicKey = sshPublicKey;
      };
    };
}
