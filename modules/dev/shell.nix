{
  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.zix.dev = {
        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
        };

        extraShellHook = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
      };

      config.devShells.default = pkgs.mkShell {
        inputsFrom = [ config.treefmt.build.devShell ];

        shellHook =
          config.pre-commit.shellHook
          + config.zix.dev.extraShellHook
          + ''
            export QMLLS_BUILD_DIRS=${pkgs.qt6.qtdeclarative}/lib/qt-6/qml/
          '';

        packages =
          with pkgs;
          [
            # Language Servers
            # keep-sorted start block=yes newline_separated=no
            bash-language-server
            lua-language-server
            marksman
            nixd
            qt6.qtdeclarative
            taplo
            vscode-json-languageserver
            yaml-language-server
            # keep-sorted end

            # Tools
            # keep-sorted start block=yes newline_separated=no
            age
            nh
            quickshell
            shellcheck
            sops
            ssh-to-age
            wayland
            # keep-sorted end
          ]
          ++ [ config.formatter ]
          ++ config.zix.dev.extraPackages
          ++ config.pre-commit.settings.enabledPackages;
      };
    };
}
