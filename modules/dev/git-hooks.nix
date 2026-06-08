{
  perSystem =
    { config, ... }:
    {
      pre-commit = {
        check.enable = true;

        settings.hooks = {
          # keep-sorted start block=yes
          deadnix = {
            enable = true;
            settings.noLambdaPatternNames = true;
          };
          editorconfig-checker.enable = true;
          statix.enable = true;
          treefmt = {
            enable = true;
            package = config.formatter;
          };
          typos = {
            enable = true;
            excludes = [
              "secrets/*"
              "\.sops\.yaml"
              "\.el$"
            ];
          };
          # keep-sorted end
        };
      };
    };
}
