{ inputs, lib }: modules: {
  mkNixos = system: name: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        modules.nixos.${name}
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
        }
      ];
    };
  };

  mkDarwin = system: name: {
    ${name} = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        modules.darwin.${name}
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
        }
      ];
    };
  };

  mkHomeManager = system: name: {
    ${name} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        modules.homeManager.${name}
        { nixpkgs.config.allowUnfree = true; }
      ];
    };
  };
}
