{ self, ... }: {
  flake.modules.nixos.desktops = { config, lib, ... }: {
    imports = with self.modules.nixos; [
      gnome
      hyprland

      gdm
      greetd
    ];

    options.zix = {
      desktops = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "gnome"
            "hyprland"
          ]
        );
        default = [ ];
      };

      greeter = lib.mkOption {
        type = lib.types.enum [
          "gdm"
          "greetd"
          "none"
        ];
        default = "none";
      };
    };

    config.zix.greeter = lib.mkIf (config.zix.desktops != [ ]) (lib.mkDefault "greetd");
  };
}
