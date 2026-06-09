{ inputs, ... }:
{
  flake.modules.darwin.homebrew = {
    imports = [ inputs.brew-nix.darwinModules.default ];
  };
}
