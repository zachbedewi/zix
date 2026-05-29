{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.overlays.emacs =
    final: prev:
    let
      emacsOverlay = inputs.emacs-overlay.overlays.default final prev;
    in
    emacsOverlay
    // {
      emacs-doom-darwin = emacsOverlay.emacs-unstable.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchurl {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
            hash = "sha256-dFH4D1WYQOVOagUuVdEQB3irxV+Y8dDAOKJOJXc/KHQ=";
          })
          (prev.fetchurl {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            hash = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
          })
        ];
      });
    };
}
