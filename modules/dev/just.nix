{
  perSystem = { pkgs, ... }: {
    zix.dev = {
      extraPackages = with pkgs; [
        just
        just-lsp
      ];

      extraShellHook = ''
        zixJustRoot="$(${pkgs.git}/bin/git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
        ln -sf ${./justfile} "$zixJustRoot/justfile"
        unset zixJustRoot
      '';
    };
  };
}
