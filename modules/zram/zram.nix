{
  flake.modules.nixos.zram = {
    zramSwap = {
      enable = true;
      memoryPercent = 50;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
  };
}
