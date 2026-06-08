{
  flake.modules.nixos.eye-of-god =
    { lib, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      nixpkgs.hostPlatform = "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = true;

      boot = {
        initrd.availableKernelModules = [
          "xhci_pci"
          "thunderbolt"
          "nvme"
        ];
        initrd.kernelModules = [ ];
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
      };

      networking.useDHCP = mkDefault true;
    };
}
