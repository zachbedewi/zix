_: {
  flake.modules.darwin.dock = {
    system.defaults.dock = {

      # Auto hide settings
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;

      # Appearance
      tilesize = 32;
      orientation = "left";
      mineffect = "scale";
      static-only = true;
      show-recents = false;
      showhidden = true;
      show-process-indicators = false;
      expose-animation-duration = 0.0;
      minimize-to-application = true;
      magnification = false;

      # Disable hot corners
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tr-corner = 1;
      wvous-tl-corner = 1;

      # Behavior
      mru-spaces = false;
      launchanim = false;
      showDesktopGestureEnabled = false;
      appswitcher-all-displays = true;
      mouse-over-hilite-stack = false;
    };
  };
}
