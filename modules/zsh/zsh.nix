{
  flake.modules.homeManager.zsh =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        dotDir = "${config.xdg.configHome}/zsh";

        defaultKeymap = "viins";
        autocd = true;

        history =
          let
            sz = 50000;
          in
          {
            path = "${config.xdg.stateHome}/zsh/history";

            size = sz;
            save = sz;

            share = true;

            ignoreDups = true;
            ignoreAllDups = true;
            expireDuplicatesFirst = true;
            extended = true;

            saveNoDups = true;
            findNoDups = true;
          };

        setOptions = [
          "AUTO_CD"
          "AUTO_PUSHD"
          "PUSHD_IGNORE_DUPS"
          "PUSHD_SILENT"
          "EXTENDED_GLOB"
          "GLOB_DOTS"
          "NO_CASE_GLOB"
          "NUMERIC_GLOB_SORT"
          "INTERACTIVE_COMMENTS"
          "NO_BEEP"
          "NO_FLOW_CONTROL"
          "CORRECT"
          "COMPLETE_IN_WORD"
          "ALWAYS_TO_END"
          "AUTO_MENU"
          "LIST_PACKED"
          "NO_CLOBBER"
          "PIPE_FAIL"
          "PROMPT_SUBST"
          "TRANSIENT_RPROMPT"
        ];

        autosuggestion = {
          enable = true;
          strategy = [
            "history"
            "completion"
          ];
          highlight = "fg=8";
        };

        historySubstringSearch = {
          enable = true;
          searchUpKey = [ "^[[A" ];
          searchDownKey = [ "^[[B" ];
        };

        plugins = [
          {
            name = "fast-syntax-highlighting";
            src = pkgs.zsh-fast-syntax-highlighting;
            file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
          }
          {
            name = "fzf-tab";
            src = pkgs.zsh-fzf-tab;
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
          }
          {
            name = "zsh-vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
          {
            name = "you-should-use";
            src = pkgs.zsh-you-should-use;
            file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
          }
          {
            name = "zsh-autopair";
            src = pkgs.zsh-autopair;
            file = "share/zsh/zsh-autopair/autopair.zsh";
          }
          {
            name = "forgit";
            src = pkgs.zsh-forgit;
            file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
          }
        ];

        initContent = lib.mkMerge [
          (lib.mkOrder 600 ''
            # Completion system styling
            zstyle ':completion:*' completer _extensions _complete _approximate
            zstyle ':completion:*' use-cache on
            zstyle ':completion:*' cache-path "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
            zstyle ':completion:*' group-name ""
            zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
            zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
            zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
            zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
            zstyle ':completion:*' squeeze-slashes true
            zstyle ':completion:*' special-dirs true
            zstyle ':completion:*:approximate:*' max-errors 'reply=($(( ($#PREFIX+$#SUFFIX)/3 )) numeric)'
            zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
            zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

            # Vi-mode menu navigation
            zmodload zsh/complist
            bindkey -M menuselect 'h' vi-backward-char
            bindkey -M menuselect 'j' vi-down-line-or-history
            bindkey -M menuselect 'k' vi-up-line-or-history
            bindkey -M menuselect 'l' vi-forward-char
            bindkey -M menuselect '^[[Z' reverse-menu-complete
          '')

          ''
            # Keep useful emacs bindings accessible in vi-mode
            bindkey '^A' beginning-of-line
            bindkey '^E' end-of-line
            bindkey '^W' backward-kill-word

            # Edit command in $EDITOR
            autoload -Uz edit-command-line
            zle -N edit-command-line
            bindkey '^X^E' edit-command-line

            # KEYTIMEOUT for snappy vi-mode escape
            export KEYTIMEOUT=1

            # Report time for long-running commands
            REPORTTIME=10

            # Named directory hashes
            hash -d dev=$HOME/dev
            hash -d dl=$HOME/Downloads

            # Directory stack size
            DIRSTACKSIZE=20

            # mkcd function
            function mkcd() { mkdir -p "$1" && cd "$1" }
          ''
        ];
      };

      home.packages = with pkgs; [
        zsh-completions
        any-nix-shell
      ];
    };
}
