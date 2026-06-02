let
  packages =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        git
        home-manager
      ];
    };
in
{
  flake.modules.nixos.generic = {
    imports = [
      packages
    ];
  };

  flake.modules.darwin.generic = {
    imports = [
      packages
    ];
  };
}
