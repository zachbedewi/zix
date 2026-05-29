{
  self,
  ...
}:
{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.base = pkgs.mkShell {
        name = "base";

        packages = with pkgs; [
          git
          gh
          act
          jq
          yq-go
          ripgrep
          fd
          httpie
          docker-client
          direnv
        ];

        shellHook = ''
          ${config.pre-commit.installationScript}
          ${self.lib.mkBanner {
            name = "zix";
            shellName = "base";
          }}
        '';
      };
    };
}
