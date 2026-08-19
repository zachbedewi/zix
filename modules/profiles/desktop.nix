{ self, ... }: {
  flake.modules = {
    nixos.desktop = {
      imports = with self.modules.nixos; [
        base
        fonts
        emacs
      ];
    };

    darwin.desktop = {
      imports = with self.modules.darwin; [
        base
        fonts
        emacs

        macos-defaults
      ];
    };

    homeManager.desktop = {
      imports = with self.modules.homeManager; [
        base

        kitty
        emacs

        aerospace
        sketchybar
        jankyborders
      ];
    };
  };
}
