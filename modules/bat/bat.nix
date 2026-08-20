{
  flake.modules.homeManager.bat = { pkgs, ... }: {
    home = {
      packages = [ pkgs.bat ];
    };
  };
}
