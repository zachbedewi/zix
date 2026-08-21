{
  flake.modules.nixos.fried-egg = {
    disko.devices = {
      disk.primary = {
        device = "/dev/disk/by-id/nvme-WDS100T1X0E-00AFY0_21522B801721";
        type = "disk";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };

      zpool.rpool = {
        type = "zpool";

        options = {
          ashift = "12";
          autotrim = "on";
        };

        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
          dnodesize = "auto";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/zix-disk.key";
          "com.sun:auto-snapshot" = "false";
        };

        postCreateHook = "zfs set keylocation=prompt rpool";

        datasets = {
          local = {
            type = "zfs_fs";
            options.canmount = "off";
          };

          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -qx rpool/local/root@blank || zfs snapshot rpool/local/root@blank";
          };

          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };

          safe = {
            type = "zfs_fs";
            options.canmount = "off";
          };

          "safe/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };

          "safe/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };

          "safe/var-lib-nixos" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/nixos";
            options.mountpoint = "legacy";
          };

          "safe/var-log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options.mountpoint = "legacy";
          };

          reserved = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              refreservation = "5G";
            };
          };
        };
      };
    };
  };
}
