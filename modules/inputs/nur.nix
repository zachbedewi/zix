{ inputs, ... }: {
  # Nix User Repository: User contributed nix packages
  # https://github.com/nix-community/nur

  flake-file.inputs = {
    nur = {
      url = "github:nix-community/NUR";
    };
  };

  flake.overlays.nur = inputs.nur.overlays.default;
}
