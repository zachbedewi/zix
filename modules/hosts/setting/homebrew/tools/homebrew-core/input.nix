{
  # Default formulae for the missing package manager for macOS
  # https://github.com/homebrew/homebrew-core

  flake-file.inputs = {
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
  };
}
