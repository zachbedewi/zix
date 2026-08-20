{ self, ... }: {
  flake.modules = {
    homeManager.cli = {
      imports = with self.modules.homeManager; [
        # keep-sorted start block=yes newline_separated=no
        bat
        bottom
        btop
        cheat
        csvkit
        duckdb
        duf
        dust
        eza
        fd
        fzf
        gron
        hyperfine
        jaq
        just
        miller
        navi
        ouch
        p7zip
        pandoc
        procs
        ripgrep
        ripgrep-all
        sd
        tealdeer
        tmux
        unar
        unzip
        visidata
        watchexec
        yazi
        yq-go
        zellij
        zip
        zoxide
        # keep-sorted end
      ];
    };
  };
}
