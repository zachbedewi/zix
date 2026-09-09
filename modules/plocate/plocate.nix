{
  flake.modules.nixos.plocate = { pkgs, ... }: {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "hourly";
    };
  };
}
