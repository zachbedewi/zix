{
  inputs,
  self,
  lib,
  ...
}:
let
  mkBuilders = import ../_lib/builders.nix {
    inherit inputs lib;
    inherit (self) overlays;
  };
in
{
  options.flake = {
    zix-lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
  };

  config = {
    flake.zix-lib = mkBuilders self.modules;

    _module.args = { inherit (self) zix-lib; };
  };
}
