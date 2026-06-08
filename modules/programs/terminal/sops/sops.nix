{ self, ... }:
let
  cfg = {
    sops = {
      defaultSopsFile = "${self}/secrets/main.yaml";
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      secrets.example_password = { };
    };
  };
in
{
  flake.modules.nixos.sops = {
    imports = [ cfg ];
  };

  flake.modules.darwin.sops = {
    imports = [ cfg ];
  };
}
