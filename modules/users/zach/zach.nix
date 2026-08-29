{
  self,
  factory,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (factory.user "zach" {
      admin = true;
      sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyV1iR8nXSf0NY0MPx4HzVwXbnJdLKGwtmKe1duw26+ zach@zix";
    })
    {
      nixos.zach = {
        imports = with self.modules.nixos; [ hyprland ];

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
          hyprland
          firefox

          gh
        ];
        home.packages = with pkgs; [ claude-code ];
      };
    }
  ];
}
