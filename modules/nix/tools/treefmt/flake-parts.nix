{
  inputs,
  ...
}:
{
  # treefmt combines formatters for multiple languages to
  # format an entire project with a single command.
  # https://github.com/numtide/treefmt-nix

  flake-file.inputs = {
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ inputs.treefmt-nix.flakeModule ];
}
