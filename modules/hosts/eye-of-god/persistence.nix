let
  hostKey = "/persist/etc/ssh/ssh_host_ed25519_key";

  bindMounts = [
    "/etc/NetworkManager/system-connections"
    "/var/lib/NetworkManager"
    "/var/lib/bluetooth"
    "/var/lib/iwd"
    "/var/lib/systemd"
    "/var/lib/fwupd"
  ];
in
{
  flake.modules.nixos.eye-of-god = { config, lib, ... }: {
    boot.initrd.systemd.services.rollback-root = {
      description = "Roll back the root dataset to its blank snapshot";
      wantedBy = [ "initrd.target" ];
      requires = [ "zfs-import-rpool.service" ];
      after = [ "zfs-import-rpool.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${config.boot.zfs.package}/bin/zfs rollback -r rpool/local/root@blank";
      };
    };

    fileSystems = lib.mkMerge [
      {
        "/persist".neededForBoot = true;
        "/var/lib/nixos".neededForBoot = true;
      }
      (lib.listToAttrs (
        map (
          path:
          lib.nameValuePair path {
            device = "/persist${path}";
            fsType = "none";
            options = [ "bind" ];
          }
        ) bindMounts
      ))
    ];

    system.activationScripts.persistence.text = lib.concatMapStringsSep "\n" (path: "mkdir -p /persist${path}") bindMounts;

    environment.etc.machine-id.text = ''
      ${builtins.substring 0 32 (builtins.hashString "sha256" config.networking.hostName)}
    '';

    services.openssh.hostKeys = [
      {
        path = hostKey;
        type = "ed25519";
      }
    ];

    sops.age.sshKeyPaths = lib.mkForce [ hostKey ];
  };
}
