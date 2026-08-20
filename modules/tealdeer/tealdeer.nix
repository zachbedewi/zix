{
  flake.modules.homeManager.tealdeer = { pkgs, ... }: {
    home = {
      packages = [ pkgs.tealdeer ];
    };
  };
}
