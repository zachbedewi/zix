{
  # Hyprland is an independent, highly customizable, dynamic tiling
  # Wayland compositor that doesn't sacrifice on its looks.
  # https://github.com/hyprwm/Hyprland

  flake-file.inputs = {
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
