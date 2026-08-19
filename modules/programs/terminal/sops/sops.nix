{ self, ... }:
let
  systemCfg = {
    sops = {
      defaultSopsFile = "${self}/secrets/main.yaml";
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      secrets.example_password = { };
    };
  };

  # Collect every home-manager user's `zix.secrets` requests and declare them as
  # system-level sops secrets owned by that user. The user name comes from the
  # attribute name in `home-manager.users`, so nothing here is hardcoded and a
  # user who requests nothing costs nothing.
  userSecrets = { config, lib, ... }: {
    sops.secrets = lib.mkMerge (
      lib.mapAttrsToList (
        username: userCfg:
        lib.mapAttrs' (
          name: secret:
          lib.nameValuePair "${username}-${name}" {
            inherit (secret) key mode path;
            sopsFile = "${self}/secrets/users/${username}.yaml";
            owner = username;
          }
        ) (userCfg.zix.secrets or { })
      ) config.home-manager.users
    );
  };
in
{
  flake.modules.nixos.sops = {
    imports = [
      systemCfg
      userSecrets
    ];
  };

  flake.modules.darwin.sops = {
    imports = [
      systemCfg
      userSecrets
    ];
  };
}
