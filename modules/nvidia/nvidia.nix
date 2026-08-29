{
  flake.modules.nixos.nvidia = { config, pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      open = true;

      nvidiaSettings = true;

      powerManagement = {
        enable = true;
        finegrained = false;
      };

      nvidiaPersistenced = true;
    };

    boot.kernelParams = [
      "nvidia_drm.fbdev=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_EnabledGpuFirmware=1"
      "nvidia.NVreg_RegistryDwords=RMIntrLockingMode=1"
    ];

    boot.blacklistedKernelModules = [ "nouveau" ];
  };
}
