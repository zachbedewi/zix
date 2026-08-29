{ lib, ... }:
let
  hostSecretType = lib.types.submodule (
    { name, ... }: {
      options = {
        mode = lib.mkOption {
          type = lib.types.str;
          default = "0400";
          description = "Permissions of the decrypted secret, in octal.";
        };

        path = lib.mkOption {
          type = lib.types.str;
          default = "/run/secrets/${name}";
          description = ''
            Where the system places the decrypted secret. Read this rather
            than hardcoding a path, and read it at runtime — the value is a
            path, never the secret itself.
          '';
        };
      };
    }
  );

  hostSecretsOption = lib.mkOption {
    default = { };
    description = ''
      Secrets this host needs, one per file at
      `secrets/<hostname>/<name>/secret.yaml`. `zix.secrets.universal.<name>`
      requests one instead from `secrets/universal/<name>/secret.yaml`,
      shared by every host.
    '';
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf hostSecretType;
      options.universal = lib.mkOption {
        type = lib.types.attrsOf hostSecretType;
        default = { };
        description = "Secrets shared by every host, not owned by this one.";
      };
    };
  };
in
{
  flake.modules = {
    homeManager.sops = { config, lib, ... }: {
      options.zix.secrets = lib.mkOption {
        default = { };
        description = ''
          Secrets this user needs, one per file at
          `secrets/<username>/<name>/secret.yaml`.

          Decryption happens at the system level using the host key; the
          system then hands each secret to this user. Nothing is decrypted
          inside home-manager, so no user-owned key material is required.
        '';
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }: {
              options = {
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
                    rather than hardcoding a path, and read it at runtime —
                    the value is a path, never the secret itself.
                  '';
                };
              };
            }
          )
        );
      };
    };

    nixos.sops.options.zix.secrets = hostSecretsOption;
    darwin.sops.options.zix.secrets = hostSecretsOption;
  };
}
