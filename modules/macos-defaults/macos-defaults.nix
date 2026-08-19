{
  flake.modules.darwin.macos-defaults = {
    system.defaults = {
      dock = {

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

      finder = {

        # Appearance
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
        _FXEnableColumnAutoSizing = true;

        # Desktop
        ShowHardDrivesOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
        ShowExternalHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;

        # Behavior
        QuitMenuItem = true;
        NewWindowTarget = "Home";
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXRemoveOldTrashItems = true;
      };

      trackpad = {

        # Functionality
        Clicking = true;
        TrackpadRightClick = true;
        ForceSuppressed = false;

        # Gestures
        TrackpadTwoFingerDoubleTapGesture = true;
        TrackpadPinch = true;
        TrackpadRotate = true;

        # Dragging
        Dragging = true;
        TrackpadThreeFingerDrag = true;

        # Feedback
        ActuateDetents = true;
        FirstClickThreshold = 1;
        SecondClickThreshold = 2;
      };
    };
  };
}
