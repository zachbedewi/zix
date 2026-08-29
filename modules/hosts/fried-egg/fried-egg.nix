{ self, ... }: {
  flake.modules.nixos.fried-egg = {
    hardware.facter.reportPath = ./facter.json;
    imports = with self.modules.nixos; [
      systemd-boot
      chrony
      zfs
      desktop
    ];
  };
}
