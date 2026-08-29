{ inputs, ... }: {
  flake.modules.nixos.impermanence = { config, lib, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    config = lib.mkIf config.zix.impermanence.enable (
      lib.mkMerge [
        {
          environment.persistence."/persist" = {
            hideMounts = true;
            directories = [ "/var/lib/nixos" ];
          };

          # The impermanence module reads `neededForBoot` off the final
          # mountpoint itself, not off the directory entry above, to decide
          # which bind mounts it has to set up before stage 2.
          fileSystems."/persist".neededForBoot = true;
          fileSystems."/var/lib/nixos".neededForBoot = true;

          environment.etc.machine-id.text = ''
            ${builtins.substring 0 32 (builtins.hashString "sha256" config.networking.hostName)}
          '';
        }

        (lib.mkIf (config.zix.impermanence.backend == "zfs") (
          let
            pool = lib.head (lib.splitString "/" config.zix.impermanence.zfs.rootSnapshot);
          in
          {
            boot.initrd.systemd.services.rollback-root = {
              description = "Roll back the root dataset to its blank snapshot";
              wantedBy = [ "initrd.target" ];
              requires = [ "zfs-import-${pool}.service" ];
              after = [ "zfs-import-${pool}.service" ];
              before = [ "sysroot.mount" ];
              unitConfig.DefaultDependencies = "no";
              serviceConfig = {
                Type = "oneshot";
                ExecStart = "${config.boot.zfs.package}/bin/zfs rollback -r ${config.zix.impermanence.zfs.rootSnapshot}";
              };
            };
          }
        ))
      ]
    );
  };
}
