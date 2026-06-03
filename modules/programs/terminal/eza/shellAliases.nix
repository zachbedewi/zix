{
  ...
}:
{
  flake.modules.homeManager.shellAliases = {
    zix.shellAliases = {
      ls = "eza";
      ll = "eza --long --all --group";
      la = "eza --long --all";
      lt = "eza --long --sort=modified";
      tree = "eza --tree";
    };
  };
}
