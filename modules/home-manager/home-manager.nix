{ inputs, ... }:
let
  settings = {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      backupCommand = "rm";
      overwriteBackup = true;
    };
  };
in
{
  flake.modules = {
    nixos.home-manager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        settings
      ];
    };

    darwin.home-manager = {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        settings
      ];
    };
  };
}
