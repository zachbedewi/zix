{
  flake.modules.nixos.nix = {
    nix = {
      gc = {
        dates = "Sat *-*-* 03:00";
        persistent = true;
      };

      optimise = {
        dates = [ "04:00" ];
      };

      settings = {
        sandbox = true;
        sandbox-fallback = false;
      };
    };
  };
}
