{ inputs, ... }: {
  perSystem =
    {
      pkgs,
      config,
      system,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShell {
          inherit (config.pre-commit) shellHook;

          packages =
            with pkgs;
            [
              config.formatter
              config.packages.bootstrap

              nixd

              sops
              age

              inputs.disko.packages.${system}.disko
              inputs.nixos-anywhere.packages.${system}.default
            ]
            ++ config.pre-commit.settings.enabledPackages;

          inputsFrom = [ config.treefmt.build.devShell ];
        };
      };
    };
}
