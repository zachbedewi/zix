{
  flake.modules.homeManager.gron = { pkgs, ... }: {
    home = {
      packages = [ pkgs.gron ];
    };
  };
}
