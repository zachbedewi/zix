{
  flake.modules.homeManager.navi = { pkgs, ... }: {
    home = {
      packages = [ pkgs.navi ];
    };
  };
}
