{
  flake.modules.nixos.chrony = {
    services.chrony = {
      enable = true;
      enableRTCTrimming = true;
      enableNTS = true;
      serverOption = "iburst";

      extraConfig = ''
        makestep 1.0 3
      '';
    };

    services.automatic-timezoned.enable = true;
  };
}
