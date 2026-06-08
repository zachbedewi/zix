{ self, ... }:

{
  flake.modules.nixos.base = {
    imports = with self.modules.nixos; [
      minimal

      generic

      ssh
      firmware
      networking
      home-manager
      sops
    ];
  };

  flake.modules.darwin.base = {
    imports = with self.modules.darwin; [
      minimal

      generic

      ssh
      home-manager
      sops

      homebrew
    ];
  };
}
