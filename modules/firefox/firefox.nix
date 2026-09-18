{
  flake.modules.homeManager.firefox = { config, lib, ... }: {
    programs.firefox = {
      enable = true;

      profiles.default = {
        isDefault = true;

        settings = {
          # Extensions installed via Nix land in a disabled scope; without
          # this Firefox requires manually enabling each one in about:addons
          # after activation.
          "extensions.autoDisableScopes" = 0;
        };

        extensions = {
          # Required because `settings` below overrides an extension's
          # stock configuration.
          force = true;

          packages = lib.mapAttrsToList (_: ext: ext.package) config.zix.firefox.extensions;
          settings = lib.mapAttrs (_: ext: { inherit (ext) settings; }) config.zix.firefox.extensions;
        };
      };
    };
  };
}
