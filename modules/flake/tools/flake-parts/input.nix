{
  # Simplify Nix Flakes with the module system
  # https://github.com/hercules-ci/flake-parts

  flake-file.inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
