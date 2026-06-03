{
  ...
}:
{
  flake.modules.homeManager.delta =
    { ... }:
    {
      programs.delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
          line-numbers = true;
        };
      };
    };
}
