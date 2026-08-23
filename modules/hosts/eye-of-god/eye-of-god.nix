{ self, ... }: {
  flake.modules.nixos.eye-of-god = {
    hardware.facter.reportPath = ./facter.json;

    boot.lanzaboote.extraEfiSysMountPoints = [ "/boot-alt" ];

    imports = with self.modules.nixos; [
      lanzaboote
      chrony
      zfs
      zram
      desktop
    ];
  };
}
