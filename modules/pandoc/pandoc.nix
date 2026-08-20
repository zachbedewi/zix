{
  flake.modules.homeManager.pandoc = { pkgs, ... }: {
    home = {
      packages = [ pkgs.pandoc ];
    };
  };
}
