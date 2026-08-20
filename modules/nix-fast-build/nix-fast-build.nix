{
  flake.modules.homeManager.nix-fast-build = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nix-fast-build ];
    };
  };
}
