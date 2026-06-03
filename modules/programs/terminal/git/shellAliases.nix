{
  ...
}:
{
  flake.modules.homeManager.shellAliases = {
    zix.shellAliases = {
      gl = "git lg";
      gs = "git status";

      ga = "git add";
      gc = "git commit";

      gp = "git push";
      gpl = "git pull";

      gd = "git diff";
      gds = "git diff --staged";
    };
  };
}
