{ inputs, ... }:
let
  cfg =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib.types) isType;
      inherit (lib.attrsets) mapAttrsToList filterAttrs mapAttrs;
    in
    {
      nix =
        let
          mappedRegistry =
            inputs |> filterAttrs (_: isType "flake") |> mapAttrs (_: flake: { inherit flake; });
        in
        {
          registry = mappedRegistry // {
            default-flake = mappedRegistry.nixpkgs;
          };

          nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

          gc = {
            automatic = true;
            options = "--delete-older-than 30d";
          };

          optimise = {
            automatic = true;
          };

          settings = {
            use-xdg-base-directories = true;

            use-registries = true;
            flake-registry = pkgs.writeText "flakes-empty.json" (
              builtins.toJSON {
                flakes = [ ];
                version = 2;
              }
            );

            substituters = [
              "https://cache.nixos.org?priority=10"
              "https://nix-community.cachix.org"
            ];

            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];

            min-free = "${toString (5 * 1024 * 1024 * 1024)}";
            max-free = "${toString (10 * 1024 * 1024 * 1024)}";

            auto-optimise-store = true;

            allowed-users = [
              "root"
              "@wheel"
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];

            max-jobs = "auto";

            keep-going = true;

            stalled-download-timeout = 20;

            log-lines = 30;

            extra-experimental-features = [
              "flakes"
              "nix-command"
              "pipe-operators"
            ];

            pure-eval = false;
            warn-dirty = false;
            http-connections = 35;
            accept-flake-config = false;
            keep-derivations = true;
            keep-outputs = true;
          };
        };
    };
in
{
  flake.modules.nixos.nix = {
    imports = [ cfg ];
  };

  flake.modules.darwin.nix = {
    imports = [ cfg ];
  };
}
