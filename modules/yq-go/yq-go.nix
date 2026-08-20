{
  flake.modules.homeManager.yq-go = { pkgs, ... }: {
    home = {
      packages = [ pkgs.yq-go ];
    };
  };
}
