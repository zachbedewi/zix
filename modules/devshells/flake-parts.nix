{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ inputs.git-hooks-nix.flakeModule ];

  flake.flakeModules.devshell = {
    imports = [
      inputs.git-hooks-nix.flakeModule
      ./lib.nix
      ./base/base.nix
      ./languages/nix/nix.nix
      ./languages/python/python.nix
    ];
  };

  flake.templates = {
    nix = {
      path = ./_templates/nix;
      description = "Nix project with devshell, treefmt, and git-hooks";
    };
    python = {
      path = ./_templates/python;
      description = "Python project with uv, ruff, pytest, and devshell";
    };
  };
}
