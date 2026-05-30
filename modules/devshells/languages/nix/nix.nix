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
          nixd
          sops
          age
          nixfmt-rfc-style
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
