{ inputs, ... }: {
  # Simplify Nix Flakes with the module system
  # https://github.com/hercules-ci/flake-parts

  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake-file.inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
