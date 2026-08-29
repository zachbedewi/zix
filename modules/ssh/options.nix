{
  flake.modules.homeManager.ssh = { lib, ... }: {
    options.zix.ssh.publicKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        This user's ed25519 SSH public key. Its private half lives at
        `secrets/users/<username>.yaml` under `ssh_key` and is handed to
        the user as a sops secret; nothing here ever sees the value, only
        its `zix.secrets.ssh_key.path`.
      '';
    };
  };
}
