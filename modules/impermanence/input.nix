{
  # Erase your darlings: reset root to a blank snapshot on every boot
  # https://github.com/nix-community/impermanence

  flake-file.inputs = {
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
