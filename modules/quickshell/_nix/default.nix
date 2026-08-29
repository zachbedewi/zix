{
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  qt6,
  quickshell,
}:
let
  version = "0.1.0";

  qs = quickshell.withModules [ ];

  cmakeBuildType = "RelWithDebInfo";

  # Source is scoped to CMakeLists.txt + plugin/ only. Editing a .qml file
  # in modules/ does not change this derivation's input hash, so it isn't
  # rebuilt. This is the whole point of the split.
  plugin = stdenv.mkDerivation {
    inherit cmakeBuildType;
    pname = "deadfall-plugin";
    inherit version;

    src = lib.fileset.toSource {
      root = ./..;
      fileset = lib.fileset.unions [
        ./../CMakeLists.txt
        ./../plugin
      ];
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];
    buildInputs = [
      qt6.qtbase
      qt6.qtdeclarative
    ];

    # It's a library, not an app — nothing to wrap.
    dontWrapQtApps = true;

    cmakeFlags = [
      (lib.cmakeFeature "ENABLE_MODULES" "plugin")
      (lib.cmakeFeature "INSTALL_QMLDIR" qt6.qtbase.qtQmlPrefix)
    ];
  };
in
stdenv.mkDerivation {
  inherit version cmakeBuildType;
  pname = "deadfall";
  src = ./..;

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  # `plugin` in buildInputs is what makes wrapQtAppsHook add its qml dir
  # to QML2_IMPORT_PATH in the generated wrapper. That is the entire
  # mechanism by which `import Deadfall.Services` resolves at runtime.
  buildInputs = [
    qs
    plugin
    qt6.qtbase
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ENABLE_MODULES" "shell")
    (lib.cmakeFeature "INSTALL_QSCONFDIR" "${placeholder "out"}/share/deadfall")
  ];

  postInstall = ''
    makeWrapper ${qs}/bin/qs $out/bin/deadfall \
      --add-flags "-p $out/share/deadfall"
  '';

  passthru = { inherit plugin qs; };

  meta = {
    description = "Zach's Quickshell-based desktop shell";
    mainProgram = "deadfall";
    platforms = lib.platforms.linux;
  };
}
