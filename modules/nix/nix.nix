{ inputs, ... }:
let
  common =
    { config, lib, ... }:
    let
      inherit (lib.types) isType;
      inherit (lib.attrsets) mapAttrsToList filterAttrs mapAttrs;
    in
    {
      nix =
        let
          mappedRegistry = inputs |> filterAttrs (_: isType "flake") |> mapAttrs (_: flake: { inherit flake; });
        in
        {
          registry = mappedRegistry // {
            default-flake = mappedRegistry.nixpkgs;
          };

          nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

          channel.enable = false;

          gc = {
            automatic = true;
            options = "--delete-older-than 30d";
          };

          optimise = {
            automatic = true;
          };

          settings = {
            use-xdg-base-directories = true;

            flake-registry = "";

            extra-substituters = [ "https://nix-community.cachix.org" ];
            extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

            min-free = 5 * 1024 * 1024 * 1024;
            max-free = 10 * 1024 * 1024 * 1024;

            max-jobs = "auto";

            fallback = true;
            keep-going = true;

            builders-use-substitutes = true;

            http-connections = 35;
            max-substitution-jobs = 32;
            stalled-download-timeout = 20;

            log-lines = 30;

            extra-experimental-features = [
              "flakes"
              "nix-command"
              "pipe-operators"
            ];

            warn-dirty = false;
            accept-flake-config = false;
            keep-derivations = true;
            keep-outputs = true;
          };
        };
    };

  nixos = {
    nix = {
      gc = {
        dates = "Sat *-*-* 03:00";
      };

      optimise = {
        dates = [ "04:00" ];
      };

      settings = {
        allowed-users = [
          "root"
          "@wheel"
        ];
        trusted-users = [ "@wheel" ];

        sandbox = true;
        sandbox-fallback = false;
      };
    };
  };

  darwin = {
    nix = {
      daemonIOLowPriority = true;

      settings = {
        allowed-users = [
          "root"
          "@admin"
        ];
        trusted-users = [ "@admin" ];
      };

      gc = {
        interval = [
          {
            Hour = 19;
            Minute = 0;
            Weekday = 6;
          }
        ];
      };

      optimise = {
        interval = [
          {
            Hour = 20;
            Minute = 0;
          }
        ];
      };
    };
  };
in
{
  flake.modules = {
    nixos.nix = {
      imports = [
        common
        nixos
      ];
    };

    darwin.nix = {
      imports = [
        common
        darwin
      ];
    };
  };
}
