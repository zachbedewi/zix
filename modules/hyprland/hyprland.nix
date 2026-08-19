{
  flake.modules = {
    nixos.hyprland = { config, lib, ... }: lib.mkIf (lib.elem "hyprland" config.zix.desktops) { programs.hyprland.enable = true; };

    homeManager.hyprland =
      { pkgs, lib, ... }:
      lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        wayland.windowManager.hyprland = {
          enable = true;
          configType = "lua";

          package = null;
          portalPackage = null;

          extraLuaFiles = {
            "00-env" = ./lua/00-env.lua;
            "10-monitors" = ./lua/10-monitors.lua;
            "20-input" = ./lua/20-input.lua;
            "30-appearance" = ./lua/30-appearance.lua;
            "40-binds" = ./lua/40-binds.lua;
            "50-rules" = ./lua/50-rules.lua;
            "60-autostart" = ./lua/60-autostart.lua;
          };
        };

        xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
          workspace.library = [ "/run/current-system/sw/share/hypr/stubs" ];
          diagnostics.globals = [ "hl" ];
        };

        home.packages = with pkgs; [
          hyprlauncher
          mako

          wl-clipboard
          grim
          slurp

          brightnessctl
          wireplumber
        ];
      };
  };
}
