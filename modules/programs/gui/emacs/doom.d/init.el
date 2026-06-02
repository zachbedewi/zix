;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       (corfu +orderless +icons)
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       doom-quit
       (emoji +unicode)
       hl-todo
       hydra
       indent-guides
       (ligatures +extra)
       minimap
       modeline
       nav-flash
       ophints
       (popup +defaults)
       (treemacs +lsp)
       unicode
       (vc-gutter +pretty)
       vi-tilde-fringe
       (window-select +numbers)
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       multiple-cursors
       rotate-text
       snippets
       word-wrap

       :emacs
       (dired +dirvish +icons)
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       vterm

       :checkers
       (syntax +childframe)
       (spell +aspell)
       grammar

       :tools
       ansible
       (debugger +lsp)
       direnv
       docker
       editorconfig
       ein
       (eval +overlay)
       (lookup +dictionary +docsets)
       (lsp +peek)
       magit
       make
       pdf
       rgb
       taskrunner
       terraform
       tree-sitter

       :os
       (:if IS-MAC macos)
       tty

       :lang
       (cc +lsp +tree-sitter)
       data
       emacs-lisp
       (go +lsp +tree-sitter)
       (graphql +lsp)
       (json +lsp +tree-sitter)
       (java +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (kotlin +lsp)
       (latex +cdlatex +lsp)
       (lua +lsp +tree-sitter)
       (markdown +grip)
       (nix +lsp +tree-sitter)
       (org +dragndrop +noter +pomodoro +present +roam2)
       (python +lsp +pyright +tree-sitter)
       rest
       (rust +lsp +tree-sitter)
       (scala +lsp +tree-sitter)
       (sh +lsp +tree-sitter)
       (web +lsp +tree-sitter)
       (yaml +lsp +tree-sitter)

       :email

       :app

       :config
       (default +bindings +smartparens))
