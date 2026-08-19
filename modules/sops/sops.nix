{ self, inputs, ... }:
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
  flake.modules = {
    nixos.sops = {
      imports = [
        inputs.sops.nixosModules.sops
        systemCfg
        userSecrets
      ];
    };

    darwin.sops = {
      imports = [
        inputs.sops.darwinModules.sops
        systemCfg
        userSecrets
      ];
    };

    homeManager.secrets = { config, lib, ... }: {
      options.zix.secrets = lib.mkOption {
        default = { };
        description = ''
          Secrets this user needs.

          Decryption happens at the system level using the host key; the system
          then hands each secret to this user. Nothing is decrypted inside
          home-manager, so no user-owned key material is required.

          Requests are collected by the system-level sops module, which derives
          the owner from the user name and reads `path` from here, so this is the
          only place the on-disk convention is defined.
        '';
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }: {
              options = {
                key = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                  description = ''
                    Key to look up in the user's sops file. Use `/` to traverse
                    nested structures.
                  '';
                };

                mode = lib.mkOption {
                  type = lib.types.str;
                  default = "0400";
                  description = "Permissions of the decrypted secret, in octal.";
                };

                path = lib.mkOption {
                  type = lib.types.str;
                  default = "/run/secrets/${config.home.username}/${name}";
                  description = ''
                    Where the system places the decrypted secret. Read this
                    rather than hardcoding a path, and read it at runtime — the
                    value is a path, never the secret itself.
                  '';
                };
              };
            }
          )
        );
      };
    };
  };
}
