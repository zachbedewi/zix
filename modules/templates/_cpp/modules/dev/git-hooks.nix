{
  perSystem = { config, ... }: {
    pre-commit = {
      check.enable = true;

      settings.hooks = {
        # keep-sorted start block=yes
        deadnix.enable = true;
        editorconfig-checker.enable = true;
        statix.enable = true;
        treefmt = {
          enable = true;
          package = config.formatter;
        };
        # keep-sorted end
      };
    };
  };
}
