{
  flake.modules.homeManager.zip = { pkgs, ... }: {
    home = {
      packages = [ pkgs.zip ];
    };
  };
}
