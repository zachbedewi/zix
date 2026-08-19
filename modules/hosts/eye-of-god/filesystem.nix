{
  flake.modules.nixos.eye-of-god = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/a72b2f7d-1459-4f32-84f2-698b3a3ec0d5";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/F0DC-0DFD";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/54447c41-fc00-4a4e-942b-a10a026cbf62"; } ];
  };
}
