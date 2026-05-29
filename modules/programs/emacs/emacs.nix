{
  inputs,
  ...
}:
{
  # System-level modules apply the overlay so pkgs include emacs-overlay packages.
  # Required because home-manager uses useGlobalPkgs = true.
  flake.modules.nixos.emacs = {
    nixpkgs.overlays = [ inputs.self.overlays.emacs ];
  };

  flake.modules.darwin.emacs = {
    nixpkgs.overlays = [ inputs.self.overlays.emacs ];
  };

  flake.modules.homeManager.emacs =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      emacsPackage = if pkgs.stdenv.isDarwin then pkgs.emacs-doom-darwin else pkgs.emacs-git-pgtk;

      flakeRoot = "${config.home.homeDirectory}/dev/zix";
    in
    {

      programs.emacs = {
        enable = true;
        package = emacsPackage;
        extraPackages =
          epkgs: with epkgs; [
            vterm
            treesit-grammars.with-all-grammars
            pdf-tools
          ];
      };

      home.packages =
        with pkgs;
        [
          # Core Doom dependencies
          git
          ripgrep
          fd
          sqlite

          # Native compilation
          binutils

          # Spell checking
          (aspellWithDicts (
            dicts: with dicts; [
              en
              en-computers
              en-science
            ]
          ))

          # Org-mode / LaTeX
          texlive.combined.scheme-medium
          graphviz
          pandoc

          # Shell tools
          shellcheck
          shfmt

          # Formatting
          prettier
          editorconfig-core-c

          # Media / Dired
          imagemagick
          poppler-utils
          ffmpegthumbnailer
          mediainfo

          # Misc
          html-tidy
          jq
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          coreutils
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          gcc
        ];

      home.sessionPath = [ "$HOME/.config/emacs/bin" ];

      home.file.".config/doom".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/programs/emacs/doom.d";

      home.activation.doom-emacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="${
          lib.makeBinPath (
            with pkgs;
            [
              git
              ripgrep
              fd
            ]
          )
        }:$PATH"
        EMACSDIR="$HOME/.config/emacs"
        DOOMBIN="$EMACSDIR/bin/doom"

        if [ ! -d "$EMACSDIR" ]; then
          run ${pkgs.git}/bin/git clone --depth 1 \
            https://github.com/doomemacs/doomemacs "$EMACSDIR"
        fi

        if [ -x "$DOOMBIN" ]; then
          run "$DOOMBIN" --yes sync 2>&1 || true
          run "$DOOMBIN" env 2>&1 || true
        fi
      '';
    };
}
