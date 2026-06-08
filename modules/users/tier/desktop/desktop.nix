{ self, ... }:
{
  flake.modules.homeManager.desktop = {
    imports = with self.modules.homeManager; [
      base

      kitty
      emacs

      aerospace
      sketchybar
      jankyborders
    ];
  };
}
