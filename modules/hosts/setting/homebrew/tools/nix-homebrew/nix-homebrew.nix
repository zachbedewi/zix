{ inputs, ... }:
{
  flake.modules.darwin.homebrew = {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  };
}
