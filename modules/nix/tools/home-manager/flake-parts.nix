{
  ...
}:
{
  # Manage a user environment using Nix
  # https://github.com/nix-community/home-manager

  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO: Uncomment after write-flake
  # imports = [ inputs.home-manager.flakeModules.home-manager ];
}
