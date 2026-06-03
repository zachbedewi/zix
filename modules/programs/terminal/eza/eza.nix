{
  ...
}:
{
  flake.modules.homeManager.eza =
    { ... }:
    {
      # TODO: Add theme with `programs.eza.theme`
      # https://github.com/eza-community/eza#custom-themes
      programs.eza = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;

        git = true;

        colors = "auto";
        icons = "auto";

        extraOptions = [
          "--group-directories-first"
          "--header"
          "--long"
          "--mounts"
        ];
      };
    };
}
