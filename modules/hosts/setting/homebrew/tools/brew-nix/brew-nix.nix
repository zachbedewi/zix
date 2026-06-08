{ inputs, ... }:
{
  flake.modules.darwin.homebrew = {
    inputs = [ inputs.brew-nix.darwinModules.default ];
  };
}
