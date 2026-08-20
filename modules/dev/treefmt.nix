{
  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";

      settings = {
        excludes = [
          ".sops.yaml"
          "flake.lock"
          "secrets/**"
          "**/facter.json"
        ];

        formatter.just.includes = [ "modules/dev/justfile" ];
      };

      programs = {
        # keep-sorted start block=yes newline_separated=no
        jsonfmt.enable = true;
        just.enable = true;
        keep-sorted.enable = true;
        mdformat = {
          enable = true;
          plugins = ps: [ ps.mdformat-gfm ];
          settings = {
            number = true;
            wrap = "keep";
          };
        };
        nixfmt = {
          enable = true;
          width = 140;
          strict = true;
        };
        shellcheck.enable = true;
        shfmt.enable = true;
        stylua = {
          enable = true;
          settings = {
            column_width = 140;
            indent_type = "Spaces";
            indent_width = 4;
          };
        };
        taplo.enable = true;
        yamlfmt.enable = true;
        # keep-sorted end
      };
    };
  };
}
