{
  self,
  factory,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (factory.user "zach" true)
    {
      nixos.zach = {
        users.users.zach = {
          initialHashedPassword = "$y$j9T$SUoqmnYrMvbqVIgktm4rl.$vRED9fj6Kxqp/XEpHd4/TS/JIMcBZTeqTM6fcG5D8r2";
          group = "audio";
        };
      };

      homeManager.zach = { pkgs, ... }: {
        imports = with self.modules.homeManager; [
          gnome
          desktop

          gh
        ];
        home.packages = with pkgs; [ mediainfo ];
      };
    }
  ];
}
