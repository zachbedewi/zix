{
  flake.modules.homeManager.cheat = { pkgs, ... }: {
    home = {
      packages = [ pkgs.cheat ];
    };
  };
}
