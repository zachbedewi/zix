{ inputs, ... }: {
  flake.modules = {
    nixos.sops = {
      imports = [ inputs.sops.nixosModules.sops ];
    };

    darwin.sops = {
      imports = [ inputs.sops.darwinModules.sops ];
    };
  };
}
