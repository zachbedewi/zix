{ inputs, self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.deadfall = pkgs.callPackage ./_nix {
      stdenv = pkgs.clangStdenv;
      quickshell = inputs.quickshell.packages.${pkgs.system}.default;
    };

    zix.dev.extraPackages = with pkgs; [
      cmake
      ninja
      pkg-config
      clang-tools
      qt6.qtbase
      qt6.qtdeclarative
    ];

    zix.dev.extraShellHook = ''
      export QUICKSHELL_QML_PATH="${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml"
    '';
  };

  flake.modules.homeManager.deadfall =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.zix.deadfall;
      pkg = self.packages.${pkgs.system}.deadfall;
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = [ pkg ];

      systemd.user.services.deadfall = {
        Unit = {
          Description = "Deadfall desktop shell";
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
        };
        Service = {
          ExecStart = if cfg.devMode then "${lib.getExe pkg} -p ${config.home.homeDirectory}/${cfg.devPath}" else lib.getExe pkg;
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
