{
  # Declarative disk partitioning and formatting
  # https://github.com/nix-community/disko

  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
