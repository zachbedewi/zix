# zix

A dendritic Nix configuration framework built on [flake-parts](https://flake.parts). Manages NixOS, nix-darwin, and home-manager configurations through a symmetric, composable module system where hosts and users are first-class citizens with mirrored capabilities.

## Philosophy

Traditional Nix configs are host-centric: you define a machine and stuff everything into it. **zix inverts this.** Programs, services, and settings are independent features. Hosts and users *import* the features they need. Secrets wire themselves up automatically based on what's imported.

The core insight: **hosts are to system modules what users are to home-manager modules.** Both can have programs, services, settings, secrets, and tiers. The framework treats them symmetrically.

## Architecture

```
modules/
├── hosts/                          # System-level configurations (NixOS/Darwin)
│   └── <hostname>/
│       ├── instance/               # Host-specific hardware, filesystems, networking
│       ├── program/                # Host-level programs (system packages)
│       ├── service/                # System services (ssh, chrony, etc.)
│       ├── setting/                # System settings (dock, finder, boot)
│       └── tier/                   # Bundles: system-minimal → system-cli → system-desktop
│
├── users/                          # User-level configurations (Home-Manager)
│   └── <username>/
│       ├── instance/               # User-specific identity, shell, home dir
│       ├── program/
│       │   ├── terminal/           # CLI tools (git, gh, fzf, etc.)
│       │   └── gui/                # GUI apps (emacs, firefox, kitty)
│       ├── service/                # User services (syncthing, etc.)
│       └── tier/                   # Bundles: user-minimal → user-cli → user-desktop
│
├── flake-parts/                    # Framework plumbing (import-tree, flake-file, lib)
└── dev/                            # Dev shells and project templates
```

## Key Concepts

### Features as Independent Modules

Every program, service, or setting is a self-contained feature. A feature can define modules across multiple classes (NixOS, Darwin, Home-Manager) in one place:

```nix
# A program that needs system-level secrets AND user-level config
flake.modules.homeManager.gh = {
  programs.gh.enable = true;
  zix.secrets.gh_token = { envVar = "GH_TOKEN"; };
};
```

### Hosts Import Users. Users Import Programs.

```nix
# Host: imports system modules + users
flake.modules.nixos.my-server = {
  imports = [ system-cli  zach  alice ];
};

# User: imports their programs via tiers or individually
flake.modules.homeManager.zach = {
  imports = [ user-desktop ];  # includes gh, git, firefox, etc.
};
```

### Automatic Secret Wiring

Programs declare secret *interfaces*. The framework automatically:
1. Detects which users import which programs
2. Creates system-level secrets with correct per-user ownership
3. Injects environment variables into the user's shell

No manual secret configuration at the host level. Import a program → secret works.

### Tiers (Role Bundles)

Tiers bundle features into progressive levels. Different users on the same machine can have different tiers:

```
user-minimal → user-cli → user-desktop
```

A server admin gets `user-cli`. A developer gets `user-desktop`. Same machine, different capabilities.

### Dependency Convention

External tool integrations follow a `/dep` pattern:
- `dep/input.nix` — declares the flake input via flake-file
- `dep/<tool>.nix` — imports the tool's modules into the correct flake-parts class

This keeps dependency declarations co-located with the features that use them.

## Secrets

Secrets use a folder hierarchy convention:

```
secrets/
├── hosts/
│   └── <hostname>/<secretname>
└── users/
    └── <username>/<secretname>
```

Host secrets are owned by root. User secrets are owned by the respective user. The secret collector bridges home-manager declarations to system-level sops-nix configuration automatically.

## Quick Start

```bash
# Rebuild Darwin system
darwin-rebuild switch --flake .

# Rebuild NixOS system
sudo nixos-rebuild switch --flake .

# Regenerate flake.nix after adding inputs
nix run .#write-flake

# Check flake validity
nix flake check

# Enter dev shell
nix develop
```

## Built With

- [flake-parts](https://github.com/hercules-ci/flake-parts) — Module system for flakes
- [import-tree](https://github.com/vic/import-tree) — Auto-import all .nix files recursively
- [flake-file](https://github.com/vic/flake-file) — Generate flake.nix from module declarations
- [home-manager](https://github.com/nix-community/home-manager) — User environment management
- [nix-darwin](https://github.com/LnL7/nix-darwin) — macOS system configuration
- [sops-nix](https://github.com/Mic92/sops-nix) — Secrets management with age/SSH keys

## Design Reference

Based on the [Dendritic Design Pattern](https://github.com/Doc-Steve/dendritic-design-with-flake-parts) for flake-parts. Extended with symmetric host/user architecture and automatic secret wiring.
