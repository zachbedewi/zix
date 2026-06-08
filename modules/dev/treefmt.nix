{
  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        # keep-sorted start block=yes newline_separated=no
        keep-sorted.enable = true;
        nixfmt = {
          enable = true;
          width = 140;
          strict = true;
        };
        shfmt.enable = true;
        # keep-sorted end
      };
    };
  };
}
