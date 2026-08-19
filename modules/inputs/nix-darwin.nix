{ inputs, ... }: {
  # Manage your macOS using Nix
  # https://github.com/nix-darwin/nix-darwin

  imports = [ inputs.nix-darwin.flakeModules.default ];

  flake-file.inputs = {
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
