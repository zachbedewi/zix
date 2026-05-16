{
  flake.modules.nixos.networking = {
    networking = {
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };

      wireless.iwd.enable = true;
      firewall.enable = true;
      enableIPv6 = true;
    };
  };
}
