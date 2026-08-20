{
  flake.modules.homeManager.tmux = { pkgs, ... }: {
    home = {
      packages = [ pkgs.tmux ];
    };
  };
}
