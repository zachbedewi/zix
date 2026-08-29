{
  flake.modules.homeManager.deadfall = { lib, ... }: {
    options.zix.deadfall = {
      devMode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Run the deadfall binary against modules/quickshell in the
          working tree instead of its installed store path. The compiled
          plugin still comes from the package either way.
        '';
      };

      devPath = lib.mkOption {
        type = lib.types.str;
        default = "dev/zix/modules/quickshell";
        description = "Path under $HOME to the deadfall working tree, used when devMode is enabled.";
      };
    };
  };
}
