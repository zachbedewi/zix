{ self, ... }:
{
  flake.modules.nixos.desktop = {
    imports = with self.modules.nixos; [
      base
      fonts
      emacs
    ];
  };

  flake.modules.darwin.desktop = {
    imports = with self.modules.darwin; [
      base
      fonts
      emacs

      dock
      finder
      trackpad
    ];
  };
}
