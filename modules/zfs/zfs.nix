{
  flake.modules.nixos.zfs = { config, ... }: {
    boot = {
      supportedFilesystems.zfs = true;
      zfs.forceImportRoot = false;
    };

    networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };
}
