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
        zix.shellAliases = {
          nfu = "nix flake update";
          nfc = "nix flake check";

          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          "....." = "cd ../../../..";
        };

        programs.zsh.shellAliases = config.zix.shellAliases;
      };
    };
}
