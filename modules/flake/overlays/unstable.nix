{ inputs, ... }: {
  flake.overlays.unstable = final: _prev: { stable = import inputs.nixpkgs-unstable { inherit (final) config system; }; };
}
