{ inputs, ... }: {
  flake.modules.darwin.darwin-tools = { pkgs, ... }: {
    environment.systemPackages = with inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}; [
      darwin-option
      darwin-rebuild
      darwin-version
      darwin-uninstaller
    ];
  };
}
