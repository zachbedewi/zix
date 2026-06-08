{
  flake.modules.homeManager.xdg =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      home = config.home.homeDirectory;
    in
    lib.mkMerge [
      {
        xdg = {
          enable = true;

          cacheHome = "${home}/.cache";
          configHome = "${home}/.config";
          dataHome = "${home}/.local/share";
          stateHome = "${home}/.local/state";
        };
      }

      (lib.mkIf pkgs.stdenv.isLinux {
        xdg = {
          userDirs = {
            enable = true;
            createDirectories = true;

            download = "${home}/Downloads";
            desktop = "${home}/Desktop";
            documents = "${home}/Documents";
            music = "${home}/Music";
            pictures = "${home}/Pictures";
            videos = "${home}/Videos";

            extraConfig = {
              SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
            };

            publicShare = null;
            templates = null;
          };

          mime.enable = true;
          mimeApps = {
            enable = true;

            defaultApplications =
              let
                browser = [ "firefox.desktop" ];
                editor = [ "emacs.desktop" ];
              in
              {
                "application/json" = browser;

                # TODO: Add dedicated PDF viewer
                "application/pdf" = browser;

                "text/html" = browser;
                "application/xml" = browser;
                "application/xhtml+xml" = browser;
                "application/xhtml_xml" = browser;
                "application/rdf+xml" = browser;
                "application/rss+xml" = browser;
                "application/x-extension-htm" = browser;
                "application/x-extension-html" = browser;
                "application/x-extension-shtml" = browser;
                "application/x-extension-xht" = browser;
                "application/x-extension-xhtml" = browser;

                "text/plain" = editor;
                "text/xml" = editor;
                "application/x-wine-extension-ini" = editor;
              };

            associations.removed = {
              # ...
            };
          };
        };
      })
    ];
}
