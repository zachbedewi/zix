;;; config.el -*- lexical-binding: t; -*-

;; --- Identity ---
(setq user-full-name "Zach Bedewi")

;; --- Theme ---
(setq doom-theme 'doom-one)

;; --- Fonts ---
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 13)
      doom-variable-pitch-font (font-spec :family "Inter" :size 14)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))

;; --- General ---
(setq display-line-numbers-type 'relative
      scroll-margin 8
      which-key-idle-delay 0.3
      undo-limit 80000000
      evil-want-fine-undo t
      truncate-string-ellipsis "…"
      confirm-kill-emacs nil)

;; --- macOS ---
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta
        mac-command-modifier 'super
        ns-use-thin-smoothing t
        browse-url-browser-function #'browse-url-default-macosx-browser))

;; --- Projectile ---
(setq projectile-project-search-path '(("~/dev" . 1)))

;; --- Org ---
(setq org-directory "~/org/"
      org-roam-directory "~/org/roam/")

(after! org
  (setq org-startup-folded 'content
        org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-log-done 'time
        org-log-into-drawer t))

(after! org-modern
  (global-org-modern-mode))

;; --- LSP ---
(after! lsp-mode
  (setq lsp-idle-delay 0.5
        lsp-log-io nil
        lsp-headerline-breadcrumb-enable t)

  ;; Bemol multi-root workspace support for Brazil workspaces
  (defun zb/bemol-workspace-folders ()
    "Add bemol-detected workspace folders to lsp-mode."
    (let* ((root (lsp-workspace-root))
           (ws-root (when root
                      (file-name-directory
                       (directory-file-name
                        (file-name-directory (directory-file-name root))))))
           (bemol-file (when ws-root
                         (expand-file-name ".bemol/ws_root_folders" ws-root))))
      (when (and bemol-file (file-exists-p bemol-file))
        (let ((folders (with-temp-buffer
                         (insert-file-contents bemol-file)
                         (split-string (buffer-string) "\n" t))))
          (dolist (folder folders)
            (when (file-directory-p folder)
              (lsp-workspace-folders-add folder)))))))

  (add-hook 'lsp-after-initialize-hook #'zb/bemol-workspace-folders))

(after! lsp-treemacs
  (setq lsp-treemacs-symbols-position-params
        '((side . right) (slot . 1) (window-width . 35))))

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t))

;; --- Tree-sitter ---
(setq +tree-sitter-hl-enabled-modes t)

;; --- Kotlin LSP ---
(after! lsp-kotlin
  (setq lsp-kotlin-language-server-path "kotlin-language-server"))

;; --- Scala LSP (Metals) ---
(after! scala-mode
  (setq lsp-metals-server-command "metals"))

;; --- Magit ---
(after! magit
  (setq magit-save-repository-buffers 'dontask
        magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; --- Vterm ---
(after! vterm
  (setq vterm-max-scrollback 10000
        vterm-timer-delay 0.01))

;; --- Format ---
(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode
            sql-mode
            tex-mode
            latex-mode
            org-msg-edit-mode))

;; --- Completion ---
(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 1))

;; --- Nix ---
(after! lsp-mode
  (add-to-list 'lsp-disabled-clients 'nix-nil)
  (setq lsp-nix-nixd-server-path "nixd"))

;; --- Typst ---
(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :config
  (setq typst-ts-mode-watch-options "--open")
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "tinymist")
      :major-modes '(typst-ts-mode)
      :server-id 'tinymist)))
  (add-hook 'typst-ts-mode-hook #'lsp))
