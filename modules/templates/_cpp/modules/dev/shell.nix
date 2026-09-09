{
  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.treefmt.build.devShell ];

        shellHook = config.pre-commit.shellHook;

        packages =
          (with pkgs; [
            # keep-sorted start block=yes newline_separated=no
            ccache
            clang-tools
            cmake
            cppcheck
            just
            ninja
            # keep-sorted end
          ])
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.gdb ]
          ++ [ config.formatter ]
          ++ config.pre-commit.settings.enabledPackages;
      };
    };
}
