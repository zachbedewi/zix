{
  flake.modules.darwin.dock = {
    system.defaults.dock = {
      static-only = true;
      show-recents = false;
      tilesize = 32;
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      mouse-over-hilite-stack = false;
      mru-spaces = false;
      launchanim = false;
      orientation = "left";
      mineffect = "scale";
      show-process-indicators = false;
      showhidden = true;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tr-corner = 1;
      wvous-tl-corner = 1;
      showDesktopGestureEnabled = false;
      expose-animation-duration = 0.0;
      magnification = false;
      minimize-to-application = true;
      appswitcher-all-displays = true;
    };
  };
}
