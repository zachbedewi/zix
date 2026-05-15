{
  inputs,
  ...
}:
{
  flake.modules.nixos.eye-of-god = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      systemd-boot
    ];

  };
}
