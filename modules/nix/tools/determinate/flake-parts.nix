{
  ...
}:
{
  # Determinate Nix is Determinate Systems' validated and secure downstream distribution of NixOS/Nix
  # https://determinate.systems/nix/
  # https://docs.determinate.systems/guides/nix-darwin/

  flake-file.inputs = {
    determinate = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
