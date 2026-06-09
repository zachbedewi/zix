{ inputs, ... }: {
  flake.modules.nixos.eye-of-god = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
      chrony
      gnome
      desktop
    ];

  };
}
