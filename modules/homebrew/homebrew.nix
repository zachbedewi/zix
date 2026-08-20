{ inputs, ... }: {
  flake.modules.darwin.homebrew = { config, lib, ... }: {
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
      # Homebrew 6.0.0 refuses to load formulae from untrusted non-official taps,
      # which aborts activation. Every tap here comes from a pinned flake input,
      # so trust them all; official taps ignore the option.
      taps = lib.mapAttrsToList (name: _: {
        inherit name;
        trusted = true;
      }) config.nix-homebrew.taps;
    };
  };
}
