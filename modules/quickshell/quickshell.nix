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
      basePkg = self.packages.${pkgs.system}.deadfall;
      # Same `deadfall` binary as the standalone package, just wrapped with
      # this user's execPath baked in instead of the store default — see
      # execPath's description for why that has to happen here rather than
      # in the flake package itself.
      pkg = basePkg.override { inherit (cfg) execPath; };
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      zix.deadfall.execPath = if cfg.devMode then "${config.home.homeDirectory}/${cfg.devPath}" else "${basePkg}/share/deadfall";

      home.packages = [ pkg ];

      systemd.user.services.deadfall = {
        Unit = {
          Description = "Deadfall desktop shell";
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
        };
        Service = {
          ExecStart = "${pkg}/bin/deadfall";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
