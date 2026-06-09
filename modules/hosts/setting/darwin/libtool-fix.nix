_: {
  # GNU libtool from nix conflicts with Apple's libtool on macOS.
  # node-gyp and other native build tools expect Apple's `libtool -static` syntax,
  # which GNU libtool does not support. This wrapper ensures Apple's libtool wins.

  flake.modules.darwin.libtool-fix = {
    home-manager.sharedModules = [
      ({ pkgs, lib, ... }: { home.packages = [ (lib.hiPrio (pkgs.writeShellScriptBin "libtool" ''exec /usr/bin/libtool "$@"'')) ]; })
    ];
  };
}
