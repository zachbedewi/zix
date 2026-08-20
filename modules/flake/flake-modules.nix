{
  inputs,
  self,
  config,
  lib,
  ...
}:
let
  # zix's own overlays, captured here because the `modules` function below
  # shadows `self` with the consumer's.
  mkBuilders = import ../_lib/builders.nix {
    inherit inputs lib;
    inherit (self) overlays;
  };
  mkFactory = import ../_lib/factory.nix;

  zixModules = config.flake.modules;

  # Re-export every zix module into the consumer's own `flake.modules`, so a
  # consumer writes `self.modules.darwin.desktop` rather than reaching through
  # `inputs.zix.modules`. The helpers are rebound to the consumer's `self`, so
  # they resolve against the merged set and need no explicit `modules` argument.
  modules = { self, ... }: {
    flake.modules = zixModules;

    _module.args = {
      zix-lib = mkBuilders self.modules;
      factory = mkFactory self.modules;
    };
  };

  # Option declarations and flake-parts extensions a consumer needs before it
  # can define hosts, users or inputs. Kept separate so a consumer can take the
  # modules without the plumbing, or vice versa.
  plumbing = {
    imports = [
      inputs.flake-parts.flakeModules.modules
      inputs.flake-file.flakeModules.default
      inputs.home-manager.flakeModules.home-manager
      inputs.nix-darwin.flakeModules.default
    ];
  };
in
{
  imports = [ inputs.flake-parts.flakeModules.flakeModules ];

  flake.flakeModules = {
    inherit modules plumbing;

    default = {
      imports = [
        plumbing
        modules
      ];
    };
  };
}
