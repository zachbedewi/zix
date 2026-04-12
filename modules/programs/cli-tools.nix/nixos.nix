{
  flake.modules.nixos.cli-tools =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        parted
      ];
    };
}
