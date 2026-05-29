{
  inputs,
  ...
}:
{
  # Darwin: install emacs-plus via Homebrew (native macOS build with all patches)
  flake.modules.darwin.emacs =
    {
      ...
    }:
    {
      nix-homebrew.taps."d12frosted/homebrew-emacs-plus" = inputs.homebrew-emacs-plus;

      homebrew = {
        taps = [ "d12frosted/emacs-plus" ];
        brews = [
          {
            name = "emacs-plus@32";
          }
        ];
      };
    };

  # NixOS: apply emacs-overlay for pgtk build
  flake.modules.nixos.emacs = {
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
      flakeRoot = "${config.home.homeDirectory}/dev/zix";
    in
    {
      # Linux only: nix-managed Emacs with pre-built C packages
      programs.emacs = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        package = pkgs.emacs-git-pgtk;
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

          # Build deps for Doom packages that compile C (vterm, pdf-tools, tree-sitter)
          cmake
          libtool
          pkg-config
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
