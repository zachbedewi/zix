{
  flake.modules.homeManager.nh = { config, pkgs, ... }: {
    home = {
      packages = [ pkgs.nh ];

      sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/dev/zix";
    };
  };
}
