{ inputs, ... }: {
  perSystem =
    {
      config,
      lib,
      pkgs,
      system,
      ...
    }:
    {
      zix.dev.extraPackages = [
        config.packages.bootstrap

        inputs.disko.packages.${system}.disko
        inputs.nixos-anywhere.packages.${system}.default
      ];

      packages.bootstrap = pkgs.writeShellApplication {
        name = "zix-bootstrap";

        runtimeInputs =
          with pkgs;
          [
            coreutils
            git
            jq
            openssh
            sops
            ssh-to-age
            yq-go

            inputs.disko.packages.${system}.disko
            inputs.nixos-anywhere.packages.${system}.default
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            nixos-facter
            nixos-install-tools
          ];

        text = builtins.readFile ./bootstrap.sh;
      };
    };
}
