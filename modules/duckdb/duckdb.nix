{
  flake.modules.homeManager.duckdb = { pkgs, ... }: {
    home = {
      packages = [ pkgs.duckdb ];
    };
  };
}
