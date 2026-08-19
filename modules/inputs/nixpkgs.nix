{ inputs, ... }: {
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  flake.overlays = {
    stable = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) config;
        inherit (final.stdenv.hostPlatform) system;
      };
    };

    unstable = final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) config;
        inherit (final.stdenv.hostPlatform) system;
      };
    };
  };
}
