{
  self,
  ...
}:
{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.python = pkgs.mkShell {
        name = "python";

        inputsFrom = [ config.devShells.base ];

        packages = with pkgs; [
          python3
          uv
          ruff
          mypy
          python3Packages.pytest
        ];

        shellHook = self.lib.mkBanner {
          name = "project";
          shellName = "python";
        };
      };
    };
}
