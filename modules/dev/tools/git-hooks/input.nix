{
  # Seamless integration of https://pre-commit.com git hooks with Nix.
  # https://github.com/cachix/git-hooks.nix

  flake-file.inputs = {
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
