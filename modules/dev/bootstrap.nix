{ inputs, ... }: {
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    {
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
