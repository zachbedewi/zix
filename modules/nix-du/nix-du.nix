{
  flake.modules.homeManager.nix-du = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nix-du ];
    };
  };
}
