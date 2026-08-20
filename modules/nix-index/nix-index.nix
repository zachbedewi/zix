{
  flake.modules.homeManager.nix-index = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nix-index ];
    };
  };
}
