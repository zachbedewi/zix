{
  flake.modules = {
    nixos.gnome =
      { config, lib, ... }:
      lib.mkIf (lib.elem "gnome" config.zix.desktops) {
        services.desktopManager.gnome.enable = true;

        programs.dconf.enable = true;
      };

    homeManager.gnome = { pkgs, ... }: {
      home.packages = with pkgs; [
        gnome-extension-manager
        gnomeExtensions.caffeine
      ];

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          enable-hot-corners = true;
        };
        "org/nemo/preferences" = {
          confirm-move-to-trash = true;
        };
        "org/gnome/shell" = {
          disable-user-extensions = false;
          disable-extension-version-validation = true;
          enabled-extensions = [ "caffeine@patapon.info" ];
        };
      };
    };
  };
}
