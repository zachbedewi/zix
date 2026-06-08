{
  # treefmt combines formatters for multiple languages to
  # format an entire project with a single command.
  # https://github.com/numtide/treefmt-nix

  flake-file.inputs = {
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
