;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(defvar header-font nil)

(setq-default enable-local-variables t)
(setq-default enable-local-eval t)

;; Cursor shape shows mode.
(setq doom-modeline-modal nil)

(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil
        lsp-enable-suggest-server-download nil))

(use-package! lsp-mode
  :config
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.git$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.data$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.idea$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\dist$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\build$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\node_modules$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.direnv$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.devenv$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\ios$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.cargo$")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]target$"))

(after! lsp-ui
  (setq lsp-ui-doc-enable nil
        lsp-ui-sideline-enable nil))

(use-package! lsp-biome
  :init
  (setq lsp-biome-organize-imports-on-save t
        lsp-biome-autofix-on-save t
        lsp-biome-format-on-save t))

;; Workaround for https://github.com/doomemacs/doomemacs/issues/7532 in MacOS 14 Sonoma
(add-hook 'doom-after-init-hook (lambda () (tool-bar-mode 1) (tool-bar-mode 0)))

;; Annoying when using org-roam
(setq auto-save-default nil)
;; Stop asking if themes are safe
(setq custom-safe-themes t)
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Cole Potrocky"
      user-mail-address "cole@potrocky.com"
      doom-theme 'doom-oksolar-light
      doom-font (font-spec :family "PragmataPro Mono Liga" :size 16)
      doom-big-font (font-spec :family "PragmataPro Liga")
      header-font (font-spec :family "PragmataPro Liga" :size 15)
      doom-variable-pitch-font (font-spec :family "Fira Sans Condensed" :size 15)
      doom-serif-font (font-spec :family "Besley*"))
;; (setq +format-with-lsp nil)
(setenv "EDITOR" "emacsclient")
(setq which-key-idle-delay 0.3)
(setq which-key-allow-multiple-replacements t)
(after! rustic
  (setq rustic-lsp-server 'rust-analyzer))
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

(setq ein:jupyter-server-use-subcommand "server")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(after! vterm
  (add-to-list 'vterm-eval-cmds '("projectile-project-root"
                                  (lambda ()
                                    (let* ((project-root (projectile-project-root)))
                                      (if project-root
                                          (progn
                                            (vterm-send-string (format "cd \"%s\"" project-root))
                                            (vterm-send-return))
                                        (message "Not in a projectile project.")))))))

(use-package! deadgrep
  :if (executable-find "rg")
  :init
  (map! "M-s" #'deadgrep))

(after! visual-fill-column
  (setq visual-fill-column-center-text t)
  (setq visual-fill-column-width 66))

(setq lispyville-key-theme
      '((operators normal)
        c-w
        (prettify insert)
        (atom-movement normal visual)
        slurp/barf-lispy
        additional
        additional-insert
        additional-movement))

;; (use-package! smartparens
;;   :hook ((smartparens-enabled-hook . evil-smartparens-mode)))

(use-package! doom-modeline
  :config
  (setq doom-modeline-height 34))

(use-package! magit-delta
  :after magit
  :if (executable-find "delta"))

(use-package! ultra-scroll-mac
  :if (eq window-system 'mac)
  :init
  (setq scroll-conservatively 101)
  :config
  (ultra-scroll-mac-mode 1))

(defun +org-auto-id-add-to-headlines-in-file ()
  "Add ID property to the current file and all its headlines."
  (when (and (or (eq major-mode 'org-mode)
                 (eq major-mode 'org-journal-mode))
             (eq buffer-read-only nil))
    (save-excursion
      (widen)
      (goto-char (point-min))
      (org-id-get-create)
      (org-map-entries #'org-id-get-create))))

(setq auth-sources '("~/.authinfo.gpg"))

(defvar +tree-sitter-inner-text-objects-map (make-sparse-keymap))
(defvar +tree-sitter-outer-text-objects-map (make-sparse-keymap))

(defvar +tree-sitter-keys-mode-map
  (let ((keymap (make-sparse-keymap)))
    (evil-define-key '(visual operator) '+tree-sitter-keys-mode
      "i" +tree-sitter-inner-text-objects-map
      "a" +tree-sitter-outer-text-objects-map)
    keymap)
  "Basic keymap for tree sitter text objects")
(use-package! evil-textobj-tree-sitter
  :when (featurep! :editor evil +everywhere)
  :after tree-sitter
  :config

  (map! (:map +tree-sitter-inner-text-objects-map
              "a" (evil-textobj-tree-sitter-get-textobj "parameter.inner")
              "f" (evil-textobj-tree-sitter-get-textobj "function.inner")
              "F" (evil-textobj-tree-sitter-get-textobj "call.inner")
              "C" (evil-textobj-tree-sitter-get-textobj "class.inner")
              "i" (evil-textobj-tree-sitter-get-textobj "conditional.inner")
              "l" (evil-textobj-tree-sitter-get-textobj "loop.inner"))
        (:map +tree-sitter-outer-text-objects-map
              "a" (evil-textobj-tree-sitter-get-textobj "parameter.outer")
              "f" (evil-textobj-tree-sitter-get-textobj "function.outer")
              "F" (evil-textobj-tree-sitter-get-textobj "call.outer")
              "C" (evil-textobj-tree-sitter-get-textobj "class.outer")
              "c" (evil-textobj-tree-sitter-get-textobj "comment.outer")
              "i" (evil-textobj-tree-sitter-get-textobj "conditional.outer")
              "l" (evil-textobj-tree-sitter-get-textobj "loop.outer")))

  (after! which-key
    (setq which-key-allow-multiple-replacements t)
    (pushnew!
     which-key-replacement-alist
     '(("" . "\\`+?evil-textobj-tree-sitter-function--\\(.*\\)\\(?:.inner\\|.outer\\)") . (nil . "\\1")))))

;; (use-package! python-black
;;   :demand t
;;   :after python)
;; (add-hook! 'python-mode-hook #'python-black-on-save-mode)
                                        ;(setq auth-sources '("~/.authinfo"))

(add-hook 'code-review-mode-hook
          (lambda ()
            ;; include *Code-Review* buffer into current workspace
            (persp-add-buffer (current-buffer))))

(after! magit
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))

;; LSP boost
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
;; End LSP boost

(use-package! difftastic
  :after magit
  :bind (:map magit-blame-read-only-mode-map
              ("D" . difftastic-magit-show)
              ("S" . difftastic-magit-show))
  :config
  (eval-after-load 'magit-diff
    '(transient-append-suffix 'magit-diff '(-1 -1)
       [("D" "Difftastic diff (dwim)" difftastic-magit-diff)
        ("S" "Difftastic show" difftastic-magit-show)])))

(use-package! jinja2-mode
  :mode (("\\.jinja2$" . jinja2-mode)))

(after! corfu
  (setq! corfu-preselect t
         corfu-max-width corfu-min-width
         corfu-auto nil
         corfu-min-width 80))

(use-package! envrc
  :hook (after-init . envrc-global-mode))

(add-to-list 'treesit-language-source-alist
             '(typst "https://github.com/uben0/tree-sitter-typst"))
(treesit-install-language-grammar 'typst)

;; (use-package! lsp-biome
;;   :init
;;   (setq lsp-biome-organize-imports-on-save t)
;;   (setq lsp-biome-organize-imports-on-save t))
