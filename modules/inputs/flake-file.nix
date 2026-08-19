{ inputs, ... }: {
  # Generate flake.nix from module options.
  # https://github.com/vic/flake-file

  imports = [ inputs.flake-file.flakeModules.default ];

  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
  };
}
