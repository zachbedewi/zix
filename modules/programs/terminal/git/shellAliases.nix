{
  ...
}:
{
  flake.modules.homeManager.shellAliases =
    { ... }:
    {
      zix.shellAliases = {
        gs = "git status";
      };
    };
}
