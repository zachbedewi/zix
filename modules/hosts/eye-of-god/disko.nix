let
  swapSize = "64G";

  mkDisk = device: espMountpoint: {
    inherit device;
    type = "disk";

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          size = "4G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = espMountpoint;
            mountOptions = [
              "umask=0077"
              "nofail"
            ];
          };
        };

        swap = {
          size = swapSize;
          content = {
            type = "swap";
            randomEncryption = true;
            discardPolicy = "pages";
            priority = 1;
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
in
{
  flake.modules.nixos.eye-of-god = {
    disko.devices = {
      disk = {
        nvme0 = mkDisk "/dev/disk/by-id/nvme-SHPP41-2000GM_SJC4N477710504B23" "/boot";
        nvme1 = mkDisk "/dev/disk/by-id/nvme-SHPP41-2000GM_SJC4N477710504B6G" "/boot-alt";
      };

      zpool.rpool = {
        type = "zpool";
        mode = "mirror";

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

          "local/var-tmp" = {
            type = "zfs_fs";
            mountpoint = "/var/tmp";
            options.mountpoint = "legacy";
          };

          safe = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              "com.sun:auto-snapshot" = "true";
            };
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

          "safe/var-lib-sbctl" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/sbctl";
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
              refreservation = "20G";
            };
          };
        };
      };
    };
  };
}
