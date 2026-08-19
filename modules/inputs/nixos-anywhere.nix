{
  # Install NixOS everywhere via SSH
  # https://github.com/nix-community/nixos-anywhere

  flake-file.inputs = {
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs = {
        disko.follows = "disko";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
