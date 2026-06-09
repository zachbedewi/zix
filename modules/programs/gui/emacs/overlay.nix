{ inputs, ... }: {
  flake-file.inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };
  };

  flake.overlays.emacs = inputs.emacs-overlay.overlays.default;
}
