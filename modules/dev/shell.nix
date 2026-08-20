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
        shellHook = config.pre-commit.shellHook + config.zix.dev.extraShellHook;

        packages =
          with pkgs;
          [
            config.formatter

            nixd

            bash-language-server
            shellcheck
            shfmt

            lua-language-server
            stylua

            marksman

            taplo
            vscode-langservers-extracted
            yaml-language-server

            nh

            age
            sops
          ]
          ++ config.zix.dev.extraPackages
          ++ config.pre-commit.settings.enabledPackages;

        inputsFrom = [ config.treefmt.build.devShell ];
      };
    };
}
