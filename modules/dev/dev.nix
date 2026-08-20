{ inputs, ... }: {
  flake.flakeModules.dev = {
    imports = [
      inputs.git-hooks.flakeModule
      inputs.treefmt.flakeModule

      ./git-hooks.nix
      ./just.nix
      ./shell.nix
      ./treefmt.nix
    ];
  };
}
