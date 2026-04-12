{
  ...
}:
{
  perSystem.treefmt = {
    flakeCheck = true;
    flakeFormatter = true;

    projectRootFile = "flake.nix";

    programs = {
      nixfmt.enable = true;
      deadnix.enable = true;
    };
  };
}
