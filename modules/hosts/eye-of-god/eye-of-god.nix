{ self, ... }: {
  flake.modules.nixos.eye-of-god = {
    imports = with self.modules.nixos; [
      lanzaboote
      amd-cpu
      nvidia
      zfs

      chrony
      plocate
      desktop
    ];

    hardware.facter.reportPath = ./facter.json;

    boot = {
      lanzaboote.extraEfiSysMountPoints = [ "/boot-alt" ];
      kernelParams = [
        "zfs.zfs_arc_max=17179869184" # 16 GiB
      ];
    };

    home-manager.users.zach = {
      xdg.configFile."hypr/monitors.lua".text = ''
        hl.monitor({
          output = "DP-5",
          mode = "3840x2160",
          position = "0x0",
          scale = 1
        })
        hl.monitor({
          output = "DP-3",
          mode = "3840x2160",
          position = "3840x0",
          scale = 1
        })
      '';
    };
  };
}
