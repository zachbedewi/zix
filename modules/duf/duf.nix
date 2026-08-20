{
  flake.modules.homeManager.duf = { pkgs, ... }: {
    home = {
      packages = [ pkgs.duf ];
    };
  };
}
