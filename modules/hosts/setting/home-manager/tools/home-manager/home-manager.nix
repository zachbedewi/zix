{ inputs, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
  };

  flake.modules.darwin.home-manager = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
  };
}
