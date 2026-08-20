{
  flake.modules.homeManager.nix-tree = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nix-tree ];
    };
  };
}
