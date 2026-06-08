_: {
  flake.modules.darwin.finder = {
    system.defaults.finder = {

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
  };
}
