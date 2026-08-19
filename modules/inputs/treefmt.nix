{ inputs, ... }: {
  # treefmt combines formatters for multiple languages to
  # format an entire project with a single command.
  # https://github.com/numtide/treefmt-nix

  imports = [ inputs.treefmt.flakeModule ];

  flake-file.inputs = {
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
