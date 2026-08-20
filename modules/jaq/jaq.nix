{
  flake.modules.homeManager.jaq = { pkgs, ... }: {
    home = {
      packages = [ pkgs.jaq ];
    };
  };
}
