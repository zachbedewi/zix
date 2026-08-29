{
  flake.modules.nixos.fried-egg = {
    zix.impermanence.enable = true;

    environment.persistence."/persist".directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/bluetooth"
      "/var/lib/iwd"
      "/var/lib/systemd"
    ];
  };
}
