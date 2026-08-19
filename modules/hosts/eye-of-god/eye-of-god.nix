{ self, ... }: {
  flake.modules.nixos.eye-of-god = {
    imports = with self.modules.nixos; [
      systemd-boot
      chrony
      gnome
      desktop
    ];
  };
}
