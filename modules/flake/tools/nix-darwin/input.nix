{
  # Manage your macOS using Nix
  # https://github.com/nix-darwin/nix-darwin

  flake-file.inputs = {
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
