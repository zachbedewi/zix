{
  flake.modules.homeManager.miller = { pkgs, ... }: {
    home = {
      packages = [ pkgs.miller ];
    };
  };
}
