{
  flake.modules.nixos.zfs = { lib, config, ... }: {
    boot = {
      kernel.sysctl = {
        "vm.swappiness" = 10;
        "vm.max_map_count" = 2147483642;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
        "kernel.split_lock_mitigate" = 0;
      };

      supportedFilesystems.zfs = true;
      zfs.forceImportRoot = false;
    };

    networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 25;
    };
  };
}
