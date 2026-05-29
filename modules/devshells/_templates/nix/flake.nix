{
  description = "A Nix project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    zix = {
      url = "github:zachbedewi/zix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.zix.flakeModules.devshell ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        { system, pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            inputsFrom = [ inputs.zix.devShells.${system}.nix ];
            packages = [
              # Add project-specific packages here
            ];
          };
        };
    };
}
