{
  flake.modules.nixos.firmware = {
    nixpkgs.config.allowUnfree = true; # enableAllFirmware depends on this
    services.fwupd.enable = true;
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
  };
}
