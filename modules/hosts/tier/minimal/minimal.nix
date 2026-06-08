{ self, ... }:
let
  nixpkgsCfg = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = with self.overlays; [
      stable
      unstable

      nur
    ];
  };
in
{
  flake.modules.darwin.minimal = {
    imports = with self.modules.darwin; [
      nix
      nixpkgsCfg

      apps-fix
      libtool-fix

      nix-darwin-tools
    ];

    system.stateVersion = 6;
  };

  flake.modules.nixos.minimal = {
    imports = with self.modules.nixos; [
      nix
      nixpkgsCfg
    ];

    system.stateVersion = "25.05";
  };

}
