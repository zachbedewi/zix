{
  flake.modules.nixos.ssh =
    {
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      services.openssh = {
        enable = true;
        ports = [ 30 ];
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          StreamLocalBindUnlink = "yes";
        };

        hostKeys = mkDefault [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];

        openFirewall = true;
        startWhenNeeded = true;
      };
    };

  flake.modules.darwin.ssh = {
    services.openssh = {
      enable = true;
    };
  };
}
