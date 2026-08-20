{
  flake.modules.homeManager.unar = { pkgs, ... }: {
    home = {
      packages = [ pkgs.unar ];
    };
  };
}
