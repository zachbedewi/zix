{
  flake.modules.homeManager.visidata = { pkgs, ... }: {
    home = {
      packages = [ pkgs.visidata ];
    };
  };
}
