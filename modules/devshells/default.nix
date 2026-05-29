{
  ...
}:
{
  perSystem =
    { config, ... }:
    {
      devShells.default = config.devShells.nix;
    };
}
