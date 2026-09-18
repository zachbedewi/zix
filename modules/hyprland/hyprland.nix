{
  inputs,
  self,
  lib,
  ...
}:
{
  flake.modules = {
    nixos =
      lib.mapAttrs (_: traits: lib.optionalAttrs (traits.desktop or null == "hyprland") { zix.desktops = [ "hyprland" ]; }) self.users
      // {
        hyprland =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              self.modules.nixos.wayland
              inputs.hyprland.nixosModules.default
            ];

            config = lib.mkIf (lib.elem "hyprland" config.zix.desktops) {
              programs.hyprland = {
                enable = true;
                withUWSM = true;
                xwayland.enable = true;
              };

              security = {

                polkit.enable = true;
                rtkit.enable = true;
                pam = {
                  services.hyprlock = { };

                  loginLimits = [
                    {
                      domain = "@users";
                      item = "nofile";
                      type = "soft";
                      value = "524288";
                    }
                    {
                      domain = "@users";
                      item = "nofile";
                      type = "hard";
                      value = "1048576";
                    }
                  ];
                };
              };

              services.dbus.implementation = "broker";
              services.gnome.gnome-keyring.enable = true;

              xdg.portal = {
                enable = true;
                xdgOpenUsePortal = true;
                extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
                config.common.default = "*";
              };
            };
          };
      };

    homeManager =
      lib.mapAttrs (
        _: traits: lib.optionalAttrs (traits.desktop or null == "hyprland") { imports = [ self.modules.homeManager.hyprland ]; }
      ) self.users
      // {
        hyprland =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          let
            flakeRoot = "${config.home.homeDirectory}/dev/zix";
          in
          lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
            wayland.windowManager.hyprland = {
              enable = true;
              configType = "lua";

              package = null;
              portalPackage = null;

              systemd.enable = false;

              extraConfig = builtins.readFile ./config/hyprland.lua;
            };

            xdg.configFile."hypr/modules".source = config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/hyprland/config/modules";
            xdg.configFile."hypr/hyprland".source = config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/hyprland/config/hyprland";

            home = {
              packages = with pkgs; [
                hyprlock
                hypridle
                hyprsunset
                hyprpicker
                hyprlauncher
                hyprshutdown
                hyprcursor
                hyprpolkitagent
                xdg-desktop-portal-hyprland

                dunst

                cliphist
                wl-clipboard

                grim
                slurp

                brightnessctl
                wireplumber
              ];

              pointerCursor.hyprcursor.enable = true;
            };

            systemd.user.services.cliphist = {
              Unit = {
                Description = "Clipboard history";
                PartOf = [ "graphical-session.target" ];
              };
              Service = {
                ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
                Restart = "on-failure";
              };
              Install.WantedBy = [ "graphical-session.target" ];
            };
          };
      };
  };
}
