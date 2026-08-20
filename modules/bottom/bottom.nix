{
  flake.modules.homeManager.bottom = { pkgs, ... }: {
    home = {
      packages = [ pkgs.bottom ];
    };
  };
}
