{
  flake.modules.nixos.amd-cpu = { lib, ... }: {
    boot.kernelParams = [
      "amd_pstate=active"
      "amd_iommu=on"
      "iommu=pt"
      "split_lock_detect=off"
      "nowatchdog"
      "nmi_watchdog=0"
    ];

    powerManagement.cpuFreqGovernor = "performance";
    services.thermald.enable = lib.mkForce false;
    hardware.amdgpu.overdrive.enable = true;

    programs.corectrl = {
      enable = true;
    };
  };
}
