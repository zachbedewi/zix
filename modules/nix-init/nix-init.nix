{
  flake.modules.homeManager.nix-init = { pkgs, ... }: {
    home = {
      packages = [ pkgs.nix-init ];
    };
  };
}
