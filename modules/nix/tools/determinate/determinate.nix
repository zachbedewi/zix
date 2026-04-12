{
  inputs,
  ...
}:
{
  flake.modules.darwin.determine = {
    imports = [ inputs.determinate.darwinModules.default ];
    nix.enable = false; # Determinate Nix handles the Nix configuration
  };
}
