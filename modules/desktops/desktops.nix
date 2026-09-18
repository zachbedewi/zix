{ self, ... }: {
  flake.modules.nixos.desktops = { config, lib, ... }: {
    imports = with self.modules.nixos; [
      hyprland
      greetd
    ];

    config.zix.greeter = lib.mkDefault (if config.zix.desktops == [ ] then "none" else "greetd");
  };
}
