{ lib, ... }: {
  options.flake.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.unspecified);
    default = { };
    description = ''
      Per-user trait registry. Each entry is a plain attrset of traits for
      that username. `admin` is consumed by `modules/users/users.nix`;
      every other trait is owned and interpreted by whichever concern
      declares it (`sshPublicKey` by `modules/ssh/`, `desktop` by
      `modules/desktops/` and `modules/hyprland/`), by reading `self.users`
      and contributing to `flake.modules.<class>.<name>` itself. Adding a
      new trait therefore never requires editing this file or
      `modules/users/users.nix`.
    '';
  };
}
