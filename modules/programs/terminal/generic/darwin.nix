{
  flake.modules.darwin.generic =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        mas
      ];
    };
}
