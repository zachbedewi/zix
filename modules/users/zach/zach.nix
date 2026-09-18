{ self, ... }: {
  flake.users.zach = {
    admin = true;
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyV1iR8nXSf0NY0MPx4HzVwXbnJdLKGwtmKe1duw26+ zach@zix";
    desktop = "hyprland";
  };

  flake.modules = {
    nixos.zach = {
      users.users.zach = {
        initialHashedPassword = "$y$j9T$SUoqmnYrMvbqVIgktm4rl.$vRED9fj6Kxqp/XEpHd4/TS/JIMcBZTeqTM6fcG5D8r2";
        group = "audio";
      };
    };

    homeManager.zach = { pkgs, ... }: {
      imports = with self.modules.homeManager; [
        # Profiles
        cli
        desktop

        # Modules
        deadfall
        firefox

        gh
      ];
      home.packages = with pkgs; [ claude-code ];

      zix.deadfall.devMode = true;
    };
  };
}
