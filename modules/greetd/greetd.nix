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
    {
      services.greetd = {
        enable = true;
        useTextGreeter = true;

        settings = {
          default_session = {
            command = lib.concatStringsSep " " [
              (lib.getExe pkgs.tuigreet)
              "--remember"
              "--remember-user-session"
              "--time"
              "--asterisks"
              "--sessions ${sessions}/share/wayland-sessions:${sessions}/share/xsessions"
            ];
            user = "greeter";
          };
        };
      };

      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };

      boot = {
        kernelParams = [
          "quiet"
          "udev.log_level=3"
        ];
        consoleLogLevel = 0;
        initrd.verbose = false;
        plymouth.enable = true;
      };

      security.pam.services.greetd.enableGnomeKeyring = true;
    };
}
