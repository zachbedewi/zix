{
  inputs,
  ...
}:
{
  flake.modules.nixos.sops = {
    imports = [ inputs.sops.nixosModules.sops ];
  };

  flake.modules.darwin.sops = {
    imports = [ inputs.sops.darwinModules.sops ];
  };

  flake.modules.homeManager.sops = {
    imports = [ inputs.sops.homeManagerModules.sops ];
  };
}
