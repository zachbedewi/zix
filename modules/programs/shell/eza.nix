{
  ...
}:
{
  flake.modules.homeManager.eza =
    { ... }:
    {
      programs.eza = {
        enable = true;
        icons = "auto";
        git = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
          "--long"
          "--mounts"
          "--color=always"
        ];
      };
    };
}
