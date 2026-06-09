{ inputs, ... }: { flake.overlays.stable = final: _prev: { stable = import inputs.nixpkgs-stable { inherit (final) config system; }; }; }
