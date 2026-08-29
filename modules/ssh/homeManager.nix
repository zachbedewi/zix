{ self, lib, ... }:
let
  hostsDir = self + "/modules/hosts";

  hostDirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  # Each host commits its own public key next to itself, as a plain
  # `ssh_host_key.pub` file rather than a Nix value, so import-tree never
  # sees it and a host with none simply contributes nothing here.
  hostPublicKeys = lib.filterAttrs (_: key: key != null) (
    lib.mapAttrs (
      name: _:
      let
        keyFile = hostsDir + "/${name}/ssh_host_key.pub";
      in
      if builtins.pathExists keyFile then lib.strings.trim (builtins.readFile keyFile) else null
    ) hostDirs
  );

  # Pinned via `ssh-keyscan github.com`, cross-checked against GitHub's
  # published fingerprints:
  # https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
  githubKnownHosts = ''
    github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
    github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
  '';
in
{
  flake.modules.homeManager.ssh = { config, lib, ... }: {
    config = lib.mkIf (config.zix.ssh.publicKey != null) {
      zix.secrets.ssh_key = { };

      home.file = {
        ".ssh/id_ed25519.pub".text = config.zix.ssh.publicKey + "\n";
        ".ssh/authorized_keys".text = config.zix.ssh.publicKey + "\n";
        ".ssh/known_hosts".text =
          lib.concatStrings (lib.mapAttrsToList (name: publicKey: "${name} ${publicKey}\n") hostPublicKeys) + githubKnownHosts;
      };

      programs.ssh = {
        enable = true;

        settings =
          (lib.mapAttrs (name: _: {
            HostName = name;
            IdentityFile = config.zix.secrets.ssh_key.path;
          }) hostPublicKeys)
          // {
            "github.com".IdentityFile = config.zix.secrets.ssh_key.path;
            "github.com".IdentitiesOnly = true;
          };
      };
    };
  };
}
