{
  flake.modules.homeManager.nix-output-monitor = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nix-output-monitor ];
    };
  };
}
