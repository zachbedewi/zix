# DO-NOT-EDIT flake.nix by hand. Run `nix run .#write-flake` after changing
# anything below, via https://github.com/vic/flake-file.
{ inputs, ... }: {
  imports = [ inputs.flake-file.flakeModules.default ];

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake-file.outputs = ''
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks.flakeModule
        inputs.treefmt.flakeModule

        ./modules/flake-file.nix
        ./modules/dev/git-hooks.nix
        ./modules/dev/shell.nix
        ./modules/dev/treefmt.nix
      ];
    }
  '';
}
