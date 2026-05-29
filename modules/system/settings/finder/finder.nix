{
  flake.modules.darwin.finder = {
    system.defaults.finder = {
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
      NewWindowTarget = "Home";
      CreateDesktop = false;
      FXRemoveOldTrashItems = true;
      ShowHardDrivesOnDesktop = false;
      _FXEnableColumnAutoSizing = true;
      FXDefaultSearchScope = "SCcf";
      ShowMountedServersOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
    };
  };
}
