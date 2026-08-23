{ inputs, ... }: {
  flake.modules.nixos.lanzaboote = { lib, ... }: {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot = {
      loader = {
        systemd-boot = {
          enable = lib.mkForce false;
          configurationLimit = lib.mkDefault 10;
        };
        efi.canTouchEfiVariables = true;
        timeout = 3;
      };

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          includeMicrosoftKeys = true;
        };
      };
    };
  };
}
