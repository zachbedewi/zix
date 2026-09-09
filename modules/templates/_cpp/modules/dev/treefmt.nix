{
  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";

      settings.excludes = [ "flake.lock" ];

      programs = {
        # keep-sorted start block=yes newline_separated=no
        clang-format.enable = true;
        jsonfmt.enable = true;
        just.enable = true;
        mdformat.enable = true;
        nixfmt.enable = true;
        shellcheck.enable = true;
        # keep-sorted end
      };
    };
  };
}
