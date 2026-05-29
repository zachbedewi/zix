{
  inputs,
  lib,
  ...
}:
{
  # helper functions for creating system / home-manager configurations

  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {

    mkNixos =
      system: name:
      {
        modules ? inputs.self.modules,
      }:
      {
        ${name} = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            modules.nixos.${name}
            { nixpkgs.hostPlatform = lib.mkDefault system; }
          ];
        };
      };

    mkDarwin =
      system: name:
      {
        modules ? inputs.self.modules,
      }:
      {
        ${name} = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            modules.darwin.${name}
            { nixpkgs.hostPlatform = lib.mkDefault system; }
          ];
        };
      };

    mkHomeManager =
      system: name:
      {
        modules ? inputs.self.modules,
      }:
      {
        ${name} = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          modules = [
            modules.homeManager.${name}
            { nixpkgs.config.allowUnfree = true; }
          ];
        };
      };

  };
}
