{
  # Emacs formulae for macOS with extra patches
  # https://github.com/d12frosted/homebrew-emacs-plus

  flake-file.inputs = {
    homebrew-emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };
  };
}
