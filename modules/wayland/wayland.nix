{
  flake.modules.nixos.wayland = { pkgs, ... }: {
    environment = {
      systemPackages = with pkgs; [
        qt5.qtwayland
        qt6.qtwayland
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
        VDPAU_DRIVER = "va_gl";

        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";

        __GL_MaxFramesAllowed = "1";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "1";

        XCURSOR_SIZE = "24";
        HYPRCURSOR_SIZE = "24";
      };
    };
  };
}
