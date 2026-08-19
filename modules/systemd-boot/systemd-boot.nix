{
  flake.modules.nixos.systemd-boot = { lib, ... }: {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = lib.mkDefault 10;
        };
        efi.canTouchEfiVariables = true;
        timeout = 3;
      };
    };
  };
}
