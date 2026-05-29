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
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/round-undecorated-frame.patch";
            hash = "sha256-JpR7ZyT8KfrdRIiYCMXPC0zmJ4zwT0YIaiHfUMjEFR0=";
          })
          (prev.fetchurl {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/system-appearance.patch";
            hash = "sha256-Uyg1A9te0oh+nXM7qq+A8sgQ5mjngumIvaWFWgsevrQ=";
          })
          (prev.fetchurl {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            hash = "sha256-H4Qj6n5uZsmsbdjjexGZctqhJk3gAXKiSnmnEO/LgTA=";
          })
        ];
      });
    };
}
