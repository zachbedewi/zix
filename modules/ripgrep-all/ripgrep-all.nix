{
  flake.modules.homeManager.ripgrep-all = { pkgs, ... }: {
    home = {
      packages = [ pkgs.ripgrep-all ];
    };
  };
}
