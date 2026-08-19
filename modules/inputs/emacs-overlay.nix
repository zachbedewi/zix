{ inputs, ... }: {
  # Bleeding edge emacs overlay
  # https://github.com/nix-community/emacs-overlay

  flake-file.inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.overlays.emacs = inputs.emacs-overlay.overlays.default;
}
