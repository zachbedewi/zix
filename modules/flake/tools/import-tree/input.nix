{
  # Import all nix files in a directory tree.
  # https://github.com/vic/import-tree

  flake-file.inputs = {
    import-tree = {
      url = "github:vic/import-tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
