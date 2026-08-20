{
  flake.modules.homeManager.csvkit = { pkgs, ... }: {
    home = {
      packages = [ pkgs.csvkit ];
    };
  };
}
