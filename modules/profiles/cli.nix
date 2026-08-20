{ self, ... }: {
  flake.modules = {
    homeManager.cli = {
      imports = with self.modules.homeManager; [
        # keep-sorted start block=yes newline_separated=no
        bat
        bottom
        btop
        cheat
        duf
        dust
        eza
        fd
        fzf
        hyperfine
        navi
        procs
        ripgrep
        ripgrep-all
        sd
        tealdeer
        tmux
        zellij
        zoxide
        # keep-sorted end
      ];
    };
  };
}
