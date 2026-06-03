{
  ...
}:
{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      config = {
        global = {
          hide_env_diff = true;
        };
      };

      nix-direnv.enable = true;
    };
  };
}
