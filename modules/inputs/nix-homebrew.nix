{
  # Homebrew installation manager for nix-darwin
  # https://github.com/zhaofengli/nix-homebrew

  flake-file.inputs = {
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
  };
}
