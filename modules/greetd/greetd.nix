{
  flake.modules.nixos.greetd =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      sessions = config.services.displayManager.sessionData.desktops;
    in
    lib.mkIf (config.zix.greeter == "greetd") {
      services.greetd = {
        enable = true;
        useTextGreeter = true;

        settings.default_session.command = lib.concatStringsSep " " [
          (lib.getExe pkgs.tuigreet)
          "--remember"
          "--remember-user-session"
          "--time"
          "--asterisks"
          "--sessions ${sessions}/share/wayland-sessions:${sessions}/share/xsessions"
        ];
      };
    };
}
