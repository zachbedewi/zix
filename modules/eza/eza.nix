{
  flake.modules.homeManager.eza = _: {
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
        "--oneline"
        "--long"
        "--all"
        "--group-directories-first"
        "--header"
        "--bytes"
      ];
    };
  };
}
