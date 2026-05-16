{
  self,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "zach" true)
    {
      nixos.zach = {
        imports = with self.modules.nixos; [
          # import modules
        ];
        users.users.zach = {
          initialHashedPassword = "$y$j9T$SUoqmnYrMvbqVIgktm4rl.$vRED9fj6Kxqp/XEpHd4/TS/JIMcBZTeqTM6fcG5D8r2";
          group = "audio";
        };
      };

      darwin.zach = {
        imports = with self.modules.darwin; [
          # import modules
        ];
      };

      homeManager.zach =
        {
          pkgs,
          ...
        }:
        {
          imports = with self.modules.homeManager; [
            system-desktop
          ];
          home.packages = with pkgs; [
            mediainfo
          ];
        };
    }
  ];
}
