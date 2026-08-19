{
  # Experimental nix expression to package all MacOS casks from homebrew automatically
  # https://github.com/BatteredBunny/brew-nix

  flake-file.inputs = {
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        nix-darwin.follows = "nix-darwin";
        brew-api.follows = "brew-api";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
