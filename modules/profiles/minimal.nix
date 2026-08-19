{ self, ... }:
let
  nixpkgsCfg = {
    nixpkgs = import ../_lib/nixpkgs.nix self.overlays;
  };
in
{
  flake.modules = {
    nixos.minimal = {
      imports = with self.modules.nixos; [
        nix
        nixpkgsCfg
      ];

      system.stateVersion = "25.05";
    };

    darwin.minimal = {
      imports = with self.modules.darwin; [
        nix
        nixpkgsCfg

        macos-fixes

        darwin-tools
      ];

      system.stateVersion = 6;
    };
  };
}
