{
  flake.modules.homeManager.nix-diff = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nix-diff ];
    };
  };
}
