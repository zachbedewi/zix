{
  flake.modules.homeManager.firefox = { lib, pkgs, ... }: {
    options.zix.firefox.extensions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            package = lib.mkOption {
              type = lib.types.package;
              description = "The extension's package, exposing `addonId` in passthru.";
            };

            settings = lib.mkOption {
              inherit (pkgs.formats.json { }) type;
              default = { };
              description = ''
                Seeded into the extension's `storage.local` on activation, so
                it starts pre-configured instead of at its stock defaults.
              '';
            };
          };
        }
      );
      default = { };
      description = ''
        Firefox extensions to install into the default profile, keyed by
        WebExtension ID. Each entry is a self-contained unit: add a new one
        from any module to install another extension without touching
        `modules/firefox/firefox.nix`.
      '';
    };
  };
}
