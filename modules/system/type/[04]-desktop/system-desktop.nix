{
  inputs,
  ...
}:
{
  # expansion of cli system for desktop use

  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-cli
      fonts
      emacs
    ];
  };

  flake.modules.darwin.system-desktop = {
    imports = with inputs.self.modules.darwin; [
      system-cli
      fonts
      emacs

      dock
      finder
      trackpad
    ];
  };

  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-cli
      browser
      kitty
      starship
      direnv
      emacs

      # Darwin window management (no-op on Linux via lib.mkIf)
      aerospace
      sketchybar
      jankyborders
    ];
  };
}
