let
  homeManagerConfig = {
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
  flake.modules.nixos.home-manager = {
    imports = [ homeManagerConfig ];
  };

  flake.modules.darwin.home-manager = {
    imports = [ homeManagerConfig ];
  };
}
