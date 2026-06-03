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
      firefox
    ];
  };

  flake.modules.darwin.system-desktop = {
    imports = with inputs.self.modules.darwin; [
      system-cli
      fonts
      emacs
      firefox

      dock
      finder
      trackpad
    ];
  };

  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-cli
      kitty
      emacs
      firefox

      # Darwin window management (no-op on Linux via lib.mkIf)
      aerospace
      sketchybar
      jankyborders
    ];
  };
}
