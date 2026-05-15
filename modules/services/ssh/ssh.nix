{
  flake.modules.nixos.ssh =
    {
      lib,
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      services.openssh = {
        enable = true;

        hostKeys = mkDefault [
          {
            bits = 4096;
            path = "/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
          }
          {
            bits = 4096;
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];

        openFirewall = true;
        ports = [ 30 ];
        startWhenNeeded = true;

        settings = {
          PermitRootLogin = "no";

          PasswordAuthentication = false;
          AuthenticationMethods = "publickey";
          PubkeyAuthentication = "yes";
          ChallengeResponseAuthentication = "no";

          StreamLocalBindUnlink = "yes";
        };
      };
    };

  flake.modules.darwin.ssh = {
    services.openssh = {
      enable = true;
    };
  };
}
