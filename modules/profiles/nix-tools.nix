{ self, ... }: {
  flake.modules = {
    homeManager.nix-tools = {
      imports = with self.modules.homeManager; [
        # keep-sorted start block=yes newline_separated=no
        comma
        nh
        nix-diff
        nix-du
        nix-fast-build
        nix-index
        nix-init
        nix-output-monitor
        nix-tree
        nurl
        nvd
        # keep-sorted end
      ];
    };
  };
}
