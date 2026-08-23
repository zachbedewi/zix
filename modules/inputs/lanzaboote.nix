{
  # Secure Boot for NixOS
  # https://github.com/nix-community/lanzaboote

  flake-file.inputs = {
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
