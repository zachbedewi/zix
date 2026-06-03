{
  ...
}:
{
  flake.modules.homeManager.shellAliases =
    { config, lib, ... }:
    {
      options.zix.shellAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };

      config = {
        programs.zsh.shellAliases = config.zix.shellAliases;
      };
    };
}
