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

      execPath = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          Config path baked into the `deadfall` binary's `-p` flag: the
          working tree when devMode is enabled, otherwise the installed
          store path. Derived from devMode/devPath and used to `override`
          the flake's deadfall package, so the systemd service and any
          `deadfall ipc` call always address the same running instance.
        '';
      };
    };
  };
}
