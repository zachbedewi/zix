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

        boot
        locale

        disko
        facter
        impermanence
      ];

      system.stateVersion = "25.05";
    };

    darwin.minimal = {
      imports = with self.modules.darwin; [
        nix
        nixpkgsCfg

        locale

        macos-fixes

        darwin-tools
      ];

      system.stateVersion = 6;
    };
  };
}
