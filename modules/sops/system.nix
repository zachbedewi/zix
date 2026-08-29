{ self, inputs, ... }:
let
  # Collects: this host's own `zix.secrets` (bare name), its
  # `zix.secrets.universal` (prefixed to avoid colliding with a host secret
  # of the same name), and every home-manager user's `zix.secrets` (prefixed
  # with the username, which also owns the decrypted file). Identical on
  # NixOS and darwin — only which sops module gets imported differs.
  secretsConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      sops.age.sshKeyPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];

      # sops-nix derives its decryption identity from the host SSH key using
      # Mic92/ssh-to-age (a plain X25519 birational-map conversion), the same
      # library used to generate the recipient keys in .sops.yaml. The `sops`
      # and `age` CLIs do NOT use that scheme for on-the-fly SSH key input —
      # they implement the age-encryption.org spec's `ssh-ed25519` stanza
      # instead, which folds the key's fingerprint in as a deliberate anti-
      # confusion measure and is permanently incompatible with the former.
      # Materializing the correctly-converted key at sops's own default
      # lookup path (`$HOME/.config/sops/age/keys.txt`) lets `sudo sops`
      # decrypt with no flags or env vars, without needing that unsupported
      # conversion at all.
      system.activationScripts.sopsAgeHostKey = lib.stringAfter [ "specialfs" ] ''
        install -d -m 0700 /root/.config/sops/age
        ${lib.getExe' pkgs.ssh-to-age "ssh-to-age"} -private-key \
          -i ${lib.head config.sops.age.sshKeyPaths} \
          > /root/.config/sops/age/keys.txt
        chmod 0600 /root/.config/sops/age/keys.txt
      '';

      sops.secrets = lib.mkMerge [
        (lib.mapAttrs (name: secret: {
          key = name;
          inherit (secret) mode path;
          sopsFile = "${self}/secrets/${config.networking.hostName}/${name}/secret.yaml";
        }) (lib.removeAttrs config.zix.secrets [ "universal" ]))

        (lib.mapAttrs' (
          name: secret:
          lib.nameValuePair "universal-${name}" {
            key = name;
            inherit (secret) mode path;
            sopsFile = "${self}/secrets/universal/${name}/secret.yaml";
          }
        ) config.zix.secrets.universal)

        (lib.mkMerge (
          lib.mapAttrsToList (
            username: userCfg:
            lib.mapAttrs' (
              name: secret:
              lib.nameValuePair "${username}-${name}" {
                key = name;
                inherit (secret) mode path;
                sopsFile = "${self}/secrets/${username}/${name}/secret.yaml";
                owner = username;
              }
            ) (userCfg.zix.secrets or { })
          ) config.home-manager.users
        ))
      ];
    };
in
{
  flake.modules.nixos.sops.imports = [
    inputs.sops.nixosModules.sops
    secretsConfig
  ];

  flake.modules.darwin.sops.imports = [
    inputs.sops.darwinModules.sops
    secretsConfig
  ];
}
