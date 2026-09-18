{
  flake.modules.nixos.base = { lib, ... }: {
    options.zix = {
      desktops = lib.mkOption {
        type = lib.types.listOf (lib.types.enum [ "hyprland" ]);
        default = [ ];
        description = ''
          Every desktop this machine has to install, derived from what its
          users chose in `flake.users.<name>.desktop` — never set by hand.
        '';
      };

      greeter = lib.mkOption {
        type = lib.types.enum [
          "greetd"
          "gdm"
          "none"
        ];
        default = "none";
        description = ''
          Machine-wide greeter, one per host. Defaults to `none`, and to
          `greetd` as soon as any user asks for a desktop.
        '';
      };
    };
  };
}
