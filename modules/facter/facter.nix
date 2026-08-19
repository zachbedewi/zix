{
  flake.modules.nixos.facter = { config, lib, ... }: {
    hardware.facter.detected.dhcp.enable = lib.mkDefault (!config.networking.networkmanager.enable);
  };
}
