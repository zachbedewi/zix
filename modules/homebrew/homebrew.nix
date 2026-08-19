{ inputs, ... }: {
  flake.modules.darwin.homebrew = { config, ... }: {
    imports = [
      inputs.brew-nix.darwinModules.default
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ];

    brew-nix = {
      enable = true;
    };

    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = config.system.primaryUser;

      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
    };

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "none";
      };
      taps = builtins.attrNames config.nix-homebrew.taps;
    };
  };
}
