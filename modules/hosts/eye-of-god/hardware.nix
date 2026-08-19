{
  flake.modules.nixos.eye-of-god = { lib, ... }: {
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

    networking.useDHCP = lib.mkDefault true;
  };
}
