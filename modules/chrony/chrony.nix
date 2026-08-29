{
  flake.modules.nixos.chrony = {
    services.chrony = {
      enable = true;
      enableRTCTrimming = true;
      enableNTS = true;
      serverOption = "iburst";
      servers = [
        "time.cloudflare.com"
        "nts.netnod.se"
        "ptbtime1.ptb.de"
      ];

      extraConfig = ''
        makestep 1.0 3
      '';
    };

    services.automatic-timezoned.enable = true;
  };
}
