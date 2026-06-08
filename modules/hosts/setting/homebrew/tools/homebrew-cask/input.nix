{
  # A CLI workflow for the administration of macOS applications distributed as binaries
  # https://github.com/homebrew/homebrew-cask

  flake-file.inputs = {
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };
}
