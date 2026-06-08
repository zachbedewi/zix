{
  # Generate flake.nix from module options.
  # https://github.com/vic/flake-file

  flake-file.inputs = {
    flake-file = {
      url = "github:vic/flake-file";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
