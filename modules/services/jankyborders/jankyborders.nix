{
  flake.modules.homeManager.jankyborders =
    { pkgs, lib, ... }:
    lib.mkIf pkgs.stdenv.isDarwin {
      services.jankyborders = {
        enable = true;
        settings = {
          active_color = "0xff7E9CD8";
          inactive_color = "0x00000000";
          width = "6.0";
          style = "round";
          hidpi = "off";
        };
      };
    };
}
