{
  perSystem = { pkgs, config, ... }: {
    devShells = {
      default = pkgs.mkShell {
        inherit (config.pre-commit) shellHook;

        packages =
          with pkgs;
          [
            config.formatter

            nixd

            sops
            age
          ]
          ++ config.pre-commit.settings.enabledPackages;

        inputsFrom = [ config.treefmt.build.devShell ];
      };
    };
  };
}
