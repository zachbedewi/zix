{
  self,
  ...
}:
{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.nix = pkgs.mkShell {
        name = "nix";

        inputsFrom = [ config.devShells.base ];

        packages = with pkgs; [
          nil
          nixd
          statix
          nix-diff
          nix-tree
          nvd
        ];

        shellHook = self.lib.mkBanner {
          name = "zix";
          shellName = "nix";
        };
      };
    };
}
