{
  ...
}:
{
  flake.modules.darwin.dock = {
    system.defaults.trackpad = {

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
}
