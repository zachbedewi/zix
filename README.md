# zix

A dendritic Nix configuration framework built on [flake-parts](https://flake.parts).

Every `.nix` file under `modules/` is imported automatically by
[import-tree](https://github.com/vic/import-tree), and `flake.nix` is generated
from the `flake-file.inputs` declarations scattered through those modules. Two
consequences drive everything below:

- **Directory depth is meaningless to Nix.** It exists only so a human can find
  things. That is why the layout rule is about *findability*, not behaviour.
- **`flake.nix` is generated. Never edit it.** Run `nix run .#write-flake` after
  changing any input, and `nix flake lock` to update the lock.

Paths containing `/_` are skipped by import-tree. `modules/_lib/` therefore holds
plain functions rather than flake modules.

## Layout

```
modules/
  _lib/            plain Nix functions, not modules (import-tree skips these)
  inputs/          one file per flake input
  flake/           flake plumbing: outputs, systems, zix-lib, flakeModules
  dev/             repo tooling: devShell, treefmt, git-hooks
  profiles/        composition only, one file per profile
  hosts/<host>/    one host instance
  users/<user>/    one user instance
  <concern>/       everything else, one directory per concern
```

## Where does a new thing go?

**A new flake input** → `modules/inputs/<input>.nix`, and nothing else. That file
owns *everything flake-level* about the input: its `flake-file.inputs` entry, any
`flake.overlays.*` derived from it, and any `imports` of its flakeModule. Then
run `nix run .#write-flake`.

**A new piece of configuration** → `modules/<concern>/<concern>.nix`, where
`<concern>` is the thing being configured (`git`, `kitty`, `homebrew`, `sops`).
That file declares *every* module class the concern needs. Do not split a concern
across directories by class: `emacs` configures a Homebrew cask on darwin, an
overlay on NixOS and a Doom install in home-manager, and all three live in
`modules/emacs/emacs.nix`.

**A new host** → `modules/hosts/<hostname>/`, with `<hostname>.nix` importing
profiles and concerns, plus a `flake-parts.nix` that calls the builder. Hostname
is derived from the directory name, so do not set `networking.hostName`.

**A new user** → `modules/users/<username>/`, with `<username>.nix` calling
`factory.user` and a `flake-parts.nix` for the standalone home configuration.

**Something reusable by more than one module** → a plain function in
`modules/_lib/`, imported explicitly. Not a module.

### Directory or single file?

Always a directory: `modules/<concern>/<concern>.nix`. The file is named after
its directory, never `default.nix`. Sidecar files (shell scripts, CSS, `doom.d/`)
sit beside the module that uses them, which is the reason the directory exists
even for a one-file concern.

## Module conventions

**No lambda header unless you use an argument.** A bare attrset is a valid
module. Write `{ flake.modules... }`, not `_: { flake.modules... }`.

**Use `self`, never `inputs.self`.** flake-parts provides both; pick one.

**Nest under `flake.modules` when a file defines more than one class.** statix
rejects three or more repeated keys, so be consistent from two:

```nix
flake.modules = {
  nixos.thing = { ... };
  darwin.thing = { ... };
};
```

**Share platform-common config through a `let` binding**, not by duplicating it:

```nix
let
  common = { ... };
in
{
  flake.modules = {
    nixos.thing.imports = [ common ];
    darwin.thing.imports = [ common ];
  };
}
```

**Prefer separate classes over `stdenv.hostPlatform.isDarwin` for system config.** A
`nixos.thing` and a `darwin.thing` are selected by the host, so the wrong one is
never evaluated. `lib.mkIf pkgs.stdenv.hostPlatform.isDarwin` at the top of a module is
reserved for home-manager, which has only one class — see `aerospace`,
`sketchybar`, `jankyborders`.

**Kebab-case** for module names, files and directories (`shell-aliases`,
`macos-defaults`). Option names under the `zix.*` namespace stay camelCase, in
line with the rest of the Nix ecosystem (`zix.shellAliases`).

**No explanatory comments.** The module structure and option names carry the
meaning. A comment is warranted only for something the code cannot state: a link
to the upstream bug or gist that justifies a workaround, as in `macos-fixes`.
Rationale belongs in the commit message.

## Profiles

Profiles are the only modules that exist purely to compose others, and they are
the answer to "what does a host get, versus a user?"

| Profile | Contains |
| --- | --- |
| `minimal` | Nix itself, nixpkgs config and overlays, platform workarounds |
| `base` | `minimal` plus ssh, home-manager, sops, and a baseline shell |
| `desktop` | `base` plus fonts, terminal, editor, window management |

One file per profile, declaring all of its classes: `profiles/base.nix` defines
`nixos.base`, `darwin.base` and `homeManager.base` together, so both halves of a
profile are visible at once.

## Bootstrapping a host

Disks are declared with [disko](https://github.com/nix-community/disko) and
hardware is detected by [nixos-facter](https://github.com/nix-community/nixos-facter).
Both modules ship in `minimal`, and both are inert until a host uses them: no
`disko.devices` means no generated `fileSystems`, no report means
`hardware.facter.enable` is false.

Facter needs no flake input. The modules live in nixpkgs as `hardware.facter.*`.

**1. Declare the host.** `modules/hosts/<host>/<host>.nix` importing profiles and
concerns, and `flake-parts.nix` calling `zix-lib.mkNixos`, as in `eye-of-god`.

**2. Declare its disks** in `modules/hosts/<host>/disko.nix`. The layout is
per-host — device paths, sizes and pool names differ per machine, so there is no
shared layout helper. disko generates `fileSystems` and `swapDevices` from it,
addressed by `/dev/disk/by-partlabel/`, which replaces a hand-written
`filesystem.nix`. A ZFS root also imports the `zfs` concern, which sets
`boot.supportedFilesystems`, autoScrub, trim, and derives the required
`networking.hostId` from the hostname.

**3. Install** with `zix-bootstrap`, which is on `PATH` in the devShell and also
runnable as `nix run .#bootstrap --`. Boot the target from a NixOS installer, then
either drive it over ssh from here:

```bash
zix-bootstrap <host> --target root@<ip>
```

or run it on the target itself, from a checkout on the installer:

```bash
zix-bootstrap <host> --local
```

**4. Commit what it wrote** — the hardware report, `.sops.yaml` and the rekeyed
secrets — and point the host at its report:

```nix
{ hardware.facter.reportPath = ./facter.json; }
```

That replaces the `hardware.nix` generated by `nixos-generate-config`. Facter sets
`nixpkgs.hostPlatform`, initrd and storage kernel modules, microcode, firmware,
graphics, bluetooth and fprintd from the report. It does **not** cover
`fileSystems` or the bootloader — disko owns the first, the host owns the second.

The `facter` concern disables facter's per-interface DHCP wherever NetworkManager
is enabled, so the two do not both try to configure the same link.

The report is committed to this **public** repo. It describes the machine in
detail and includes an `smbios` section; read one before committing it if that
matters to you.

### What `zix-bootstrap` does

`modules/dev/bootstrap.nix` wraps `modules/dev/bootstrap.sh`. It runs five steps
against a host that is already declared in this flake — it never invents a host
for you, and it never commits, pushes or touches a running system.

| Step | What happens |
| --- | --- |
| preflight | resolves the repo root, checks `modules/hosts/<host>/` exists, echoes the target |
| hardware | runs `nixos-facter` and writes `modules/hosts/<host>/facter.json`, then `git add -N`s it, because a file git does not know about is invisible to the flake |
| flake checks | evaluates the host's `toplevel` and reads `disko.devices.disk`, so a broken config fails before any disk is touched |
| secrets | generates the host's ed25519 key, converts it to an age recipient with `ssh-to-age`, adds it to `.sops.yaml`, and rekeys every secret with `sops updatekeys` |
| install | prints the disks, demands confirmation, then partitions, formats and installs |

Each step is idempotent. An existing report is reused unless you pass
`--refresh-facter`, and an existing `.sops.yaml` entry for the host is updated in
place rather than duplicated — anchors, aliases and comments all survive.

| Option | Meaning |
| --- | --- |
| `--target <[user@]addr>` | install onto a remote installer over ssh, with nixos-anywhere. Bare addresses get `root@` |
| `--local` | install onto the machine running the script, which must be an installer with the disks attached |
| `--ssh-port <port>` | port of the *installer's* sshd, default 22. Not the port the host ends up on |
| `--host-key <file>` | reuse an ed25519 private key as the host key instead of generating one |
| `--save-host-key <dir>` | also write the generated key to `<dir>` |
| `--refresh-facter` | regenerate the report even if one exists |
| `--no-facter` | do not generate a report |
| `--no-secrets` | do not provision a host key and do not touch `.sops.yaml` |
| `--dry-run` | print every command that would run, change nothing |
| `-y`, `--yes` | skip the confirmation prompt |

Four things are worth knowing before the first run.

**The host key is generated here, not on the target.** sops encrypts to the
host's age recipient, which is derived from its ssh host key — so that key has to
exist *before* the system is built, or the machine boots with secrets it cannot
read. The script generates the keypair locally, rekeys against it, and hands the
private half to nixos-anywhere via `--extra-files` so it lands at
`/etc/ssh/ssh_host_ed25519_key` on the installed system. The local copy is in a
`mktemp -d` that is removed on exit unless you asked for `--save-host-key`.

**Rekeying needs a key that can already decrypt.** `sops updatekeys` re-encrypts
to the new recipient list, which means decrypting first. The `admin` key in
`.sops.yaml` has to be available to you locally, or the secrets step fails with
sops' own error and nothing is installed.

**Reinstalling a machine is a different command than installing one.** A fresh
install wants a fresh key; a rebuild of a machine that already appears in
`.sops.yaml` wants `--host-key` pointed at its existing key, otherwise you rotate
its identity and every other host's secrets get rekeyed for no reason.

**Root access disappears at the reboot.** The `ssh` concern puts sshd on port 30
with root and password login disabled, so the installer's `root@` access is gone
once the host comes back up. Reach it as your own user:
`ssh -p 30 <user>@<addr>`, and confirm the secrets arrived with `ls /run/secrets`.

Start with `--dry-run`: it prints the disks that would be destroyed and the exact
`nixos-anywhere` invocation without changing a file. If you would rather do it by
hand, the equivalent is:

```bash
sudo nixos-facter -o modules/hosts/<host>/facter.json
git add -N modules/hosts/<host>/facter.json
sudo disko --mode destroy,format,mount --flake .#<host>
sudo nixos-install --flake .#<host>
```

plus generating the host key, adding it to `.sops.yaml`, running
`sops updatekeys` on every secret, and copying the key to
`/mnt/etc/ssh/ssh_host_ed25519_key` before `nixos-install`.

## Adding a package

Where a package goes follows from who needs it:

- One user → `home.packages` in the relevant `modules/<concern>/`.
- Every user on a host → `environment.systemPackages` in
  `modules/system-packages/`.
- A specific machine or person → that machine's `modules/hosts/<host>/` or that
  person's `modules/users/<user>/`.

Two escape hatches exist for when the base channel is wrong, and they mean what
they say regardless of which channel `nixpkgs` tracks:

```nix
pkgs.stable.<package>    # nixpkgs-stable
pkgs.unstable.<package>  # nixpkgs-unstable
```

Keep `nixpkgs-stable` and `nixpkgs-unstable` pinned independently in
`modules/inputs/nixpkgs.nix`. Do not make either `follows` the base channel, or
the guarantee is lost.

## Secrets

Secrets are [sops-nix](https://github.com/Mic92/sops-nix) encrypted with **host**
age keys, derived from each machine's SSH host key. Users are not identities:
adding a machine means adding its host key to `.sops.yaml` and running
`sops updatekeys`.

Decryption happens at the system level as root, which then hands each secret to
the owning user. Nothing is decrypted inside home-manager, so no user-owned key
material is needed anywhere.

To give a user a secret, declare the need — do not name a path:

```nix
flake.modules.homeManager.gh = { config, ... }: {
  zix.secrets.gh_token = { };

  programs.zsh.initContent = ''
    [[ -r ${config.zix.secrets.gh_token.path} ]] &&
      export GH_TOKEN="$(cat ${config.zix.secrets.gh_token.path})"
  '';
};
```

The system-level sops module collects every `zix.secrets` request across
`home-manager.users`, derives the owner from the user name, and reads the value
from `secrets/users/<username>.yaml`. Consume `.path` and read it **at runtime**;
it is a path, never the secret itself. Putting a secret in a Nix string would
copy it into the world-readable store.

Rules of thumb:

- Never interpolate a secret's *value* into a module. Only its `.path`.
- Add the encrypted file at `secrets/users/<username>.yaml`; per-host and shared
  secrets go in `secrets/main.yaml`.
- A user who requests nothing costs nothing — no secret is decrypted for them.

### Known limitation

The store path is resolved as `"${self}/secrets/..."`, where `self` is **this**
flake. A downstream flake that consumes zix and adds a user with secrets must
therefore commit that user's encrypted file *here*, and add its host key to this
`.sops.yaml`. Values stay encrypted, but the recipients, the secret names and the
existence of those machines are public. This is a known and accepted trade-off,
not an oversight; fixing it means making the secrets root an option that the
consuming flake sets.

## Consuming zix from another flake

zix is a library. A downstream flake declares hosts and users and takes the
modules from here. The dependency only runs that way: a public flake cannot take
a private input without publishing its URL and revision in the lock file and
breaking any clone that lacks access.

```nix
# flake.nix — zix, flake-parts and import-tree are the only inputs needed
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
  inputs = {
    zix.url = "github:zachbedewi/zix";
    flake-parts.follows = "zix/flake-parts";
    import-tree.follows = "zix/import-tree";
  };
}
```

```nix
# modules/flake/zix.nix
{ inputs, ... }: { imports = [ inputs.zix.flakeModules.default ]; }
```

That single import provides:

| flakeModule | Provides |
| --- | --- |
| `plumbing` | flake-parts, flake-file, home-manager and nix-darwin flakeModules, including the `darwinConfigurations` option |
| `modules` | zix's `flake.modules` merged into your own, plus `zix-lib` and `factory` rebound to your flake |
| `default` | both |

Take them separately if you want zix's modules but your own plumbing.

Because `modules` merges into your namespace, downstream code refers to zix's
modules and its own the same way, and the builders need no module argument:

```nix
# modules/hosts/cocoon/cocoon.nix
{ self, ... }: {
  flake.modules.darwin.cocoon = {
    imports = with self.modules.darwin; [ desktop zbbedewi ];
  };
}

# modules/hosts/cocoon/flake-parts.nix
{ zix-lib, ... }: { flake.darwinConfigurations = zix-lib.mkDarwin "aarch64-darwin" "cocoon"; }

# modules/users/zbbedewi/zbbedewi.nix
{ self, factory, lib, ... }: {
  flake.modules = lib.mkMerge [
    (factory.user "zbbedewi" true)
    { homeManager.zbbedewi.imports = with self.modules.homeManager; [ desktop gh ]; }
  ];
}
```

Everything above applies downstream too — same layout, same module conventions.

## Working on this repo

```bash
nix develop                  # devShell (also entered automatically via direnv)
nix run .#write-flake        # regenerate flake.nix after changing an input
nix flake lock               # update flake.lock
nix flake check              # formatting, lint and pre-commit hooks
treefmt                      # format
zix-bootstrap --help         # install a host; see "Bootstrapping a host"
```

After changing a pre-commit hook, re-enter the devShell (`direnv reload`, or
`nix develop --command true`). `.pre-commit-config.yaml` is a symlink into the
store written when the shell starts, so `nix flake check` can pass while the
installed git hook still runs the previous config.

`nix flake check` runs `treefmt`, `statix`, `deadnix`, `editorconfig-checker` and
`typos`. It does **not** build the configurations, so check those explicitly:

```bash
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.<host>.config.system.build.toplevel.drvPath
nix eval .#homeConfigurations.<user>.config.home.homeDirectory
```
