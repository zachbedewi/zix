{
  flake.modules.homeManager.nurl = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nurl ];
    };
  };
}
