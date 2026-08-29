{
  flake.modules.nixos.impermanence = { lib, ... }: {
    options.zix.impermanence = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether this host wipes its root back to blank on every boot,
          keeping only /persist. Concerns that need a path to survive a
          reboot add it to `environment.persistence."/persist"` directly.
        '';
      };

      backend = lib.mkOption {
        type = lib.types.enum [ "zfs" ];
        default = "zfs";
        description = ''
          How root is reset on boot. Only "zfs" (a `zfs rollback` in the
          initrd) is implemented; a host on another filesystem has nothing
          to select yet.
        '';
      };

      zfs.rootSnapshot = lib.mkOption {
        type = lib.types.str;
        default = "rpool/local/root@blank";
        description = ''
          `dataset@snapshot` rolled back on every boot when backend is
          "zfs". The pool name is read out of this same string to order the
          rollback after that pool's import.
        '';
      };
    };
  };
}
