{
  flake.modules.homeManager.zellij = { pkgs, ... }: {
    home = {
      packages = [ pkgs.zellij ];
    };
  };
}
