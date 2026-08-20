{
  flake.modules.homeManager.comma = { pkgs, ... }: {
    home = {
      packages = [ pkgs.comma ];
    };
  };
}
