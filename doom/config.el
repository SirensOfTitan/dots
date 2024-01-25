;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(defvar header-font nil)

;; Workaround for https://github.com/doomemacs/doomemacs/issues/7532 in MacOS 14 Sonoma
(add-hook 'doom-after-init-hook (lambda () (tool-bar-mode 1) (tool-bar-mode 0)))

;; Annoying when using org-roam
(setq auto-save-default nil)
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Cole Potrocky"
      user-mail-address "cole@potrocky.com"
      doom-theme 'kaolin-valley-light
      doom-font (font-spec :family "PragmataPro Mono Liga" :size 16)
      doom-big-font (font-spec :family "Inter")
      header-font (font-spec :family "Inter" :size 15)
      doom-variable-pitch-font (font-spec :family "Vollkorn" :size 15)
      doom-serif-font (font-spec :family "Vollkorn"))
(setq +format-with-lsp nil)
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
;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")

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

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :hook ((nov-mode . visual-line-mode)
         (nov-mode . visual-fill-column-mode))
  :config
  (setq nov-text-width t)
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))

(map! :mode nov-mode
      :nvi "n" #'nov-next-document
      :nvi "p" #'nov-previous-document
      :nvi "t" #'nov-goto-toc)

(use-package! org-anki
  :config
  (setq org-anki-default-deck "General")
  (setq org-anki-default-match "+anki"))

(use-package! mixed-pitch
  :hook (org-mode . mixed-pitch-mode)
  :config
  (pushnew! mixed-pitch-fixed-pitch-faces
            'org-date
            'org-special-keyword
            'org-property-value
            'org-drawer
            'org-ref-cite-face
            'org-tag
            'org-todo-keyword-todo
            'org-todo-keyword-habt
            'org-todo-keyword-done
            'org-todo-keyword-wait
            'org-todo-keyword-kill
            'org-todo-keyword-outd
            'org-todo
            'org-done
            'font-lock-comment-face
            'line-number
            'line-number-current-line))

;; Set org faces

(use-package! magit-delta
  :after magit
  :if (executable-find "delta"))

(custom-set-faces!
  '(org-level-1 :family "Besley*" :weight semi-bold :height 1.3)
  '(org-level-2 :family "Besley*" :weight semi-bold :height 1.1)
  '(org-level-3 :family "Besley*" :weight semi-bold)
  '(org-level-4 :family "Besley*" :weight medium)
  '(org-level-5 :family "Besley*" :weight medium)
  '(org-level-6 :family "Besley*" :weight medium)
  '(org-level-7 :family "Besley*" :weight medium))

(with-eval-after-load 'org-superstar
  (set-face-attribute 'org-superstar-header-bullet nil :height 1.1)
  (set-face-attribute 'org-superstar-item nil :height 2.0)
  (set-face-attribute 'org-superstar-leading nil :height 0.5))

(use-package! dired
  :hook (dired-mode . dired-omit-mode)
  :config
  (setq dired-omit-files "^\\.[^.].*$"))

(use-package! org
  :config
  (setq org-adapt-indentation nil)
  (setq org-indent-indentation-per-level 1)
  (setq org-hide-emphasis-markers t)
  (setq org-default-notes-file (concat org-directory "inbox.org"))
  (setq org-catch-invisible-edits 'show-and-error)
  (setq org-reverse-note-order t))

(after! org (add-to-list 'org-modules 'org-habit t))
(setq org-journal-file-type 'monthly)

(add-hook 'org-mode-hook #'org-appear-mode)

(add-hook 'org-mode-hook #'doom-disable-line-numbers-h)

(after! org
  (setq org-attach-dir-relative t))

(use-package! org-transclusion
  :defer
  :after org
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

(use-package! ox-hugo
  :after org)

(defun org-roam-node-filetitle (node)
  "Return the file TITLE for the node."
  (org-roam-get-keyword "TITLE" (org-roam-node-file node)))

(defun org-roam-node-hierarchy (node)
  "Return the hierarchy for the node."
  (let ((title (org-roam-node-title node))
        (olp (org-roam-node-olp node))
        (level (org-roam-node-level node))
        (filetitle (org-roam-node-filetitle node)))
    (concat
     (if (> level 0) (concat filetitle " > "))
     (if (> level 1) (concat (string-join olp " > ") " > "))
     title))
  )

(defun colep/org-roam--is-daily-note (path)
  "Determine if note at PATH is a daily note."
  (when org-roam-dailies-directory
    (string-prefix-p
     (expand-file-name org-roam-dailies-directory)
     (expand-file-name path))))

(defun colep/org-roam--map-title (item)
  "Map ITEM to a local title name."
  (let* ((file-path (nth 1 item))
         (title (nth 0 item))
         (is-daily-note (colep/org-roam--is-daily-note file-path)))
    (if is-daily-note (concat title " 📅") title)))

(defun colep/org-roam--get-titles ()
  "Return all distinct titles and aliases in the org-roam database."
  (mapcar #'colep/org-roam--map-title (org-roam-db-query [:select [title file]
                                                          :from nodes
                                                          :union
                                                          :select [alias ""]
                                                          :from aliases])))

(advice-add #'org-roam--get-titles :override #'colep/org-roam--get-titles)

(defun colep/org-roam-node-random (&optional other-window)
  "Find a random Org-roam node not in the daily notes collection.
With prefix argument OTHER-WINDOW, visit the node in another
window instead."
  (interactive current-prefix-arg)
  (if (not org-roam-dailies-directory)
      (org-roam-node-random other-window)
    (let* ((expanded-dir (expand-file-name org-roam-dailies-directory))
           (where-pred (concat expanded-dir "%"))
           (results (org-roam-db-query [:select [id file pos] :from nodes :where (not-like file $s1)] where-pred))
           (random-row (seq-random-elt results)))
      (org-roam-node-visit (org-roam-node-create :id (nth 0 random-row)
                                                 :file (nth 1 random-row)
                                                 :point (nth 2 random-row))
                           other-window))))

(setq enable-local-variables t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;

(use-package! ultra-scroll-mac
  :if (eq window-system 'mac)
  :init
  (setq scroll-conservatively 101)
  :config
  (ultra-scroll-mac-mode 1))

(after! (org-roam)
  (winner-mode +1)
  (map! :map winner-mode-map
        "<M-right>" #'winner-redo
        "<M-left>" #'winner-undo))

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

;; (use-package! company
;;   :config
;;   (setq company-idle-delay nil))

(setq auth-sources '("~/.authinfo.gpg"))

(after! circe
  (set-irc-server! "irc.libera.chat"
    `(:tls t
      :port 6697
      :nick "colep"
      :sasl-password my-nickserver-password)))

;; (setq-hook! 'web-mode-hook +format-with 'dprint)

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

;; (use-package! lsp-bridge
;;   :config
;;   (setq lsp-bridge-python-lsp-server "pyright")
;;   (setq lsp-bridge-nix-lsp-server "nil")
;;   (setq lsp-bridge-enable-log nil)
;;   (map! :map acm-mode-map
;;         [tab]           #'acm-select-next
;;         [backtab]       #'acm-select-prev)
;;   (map! :map doom-leader-code-map
;;         :desc "LSP rename"
;;         "r"             #'lsp-bridge-rename
;;         :desc "find declaration"
;;         "j"             #'lsp-bridge-find-declaration)
;;   (require 'yasnippet)
;;   (yas-global-mode 1)
;;   (global-lsp-bridge-mode))

(use-package! corfu
  :defer t
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t
	corfu-auto-delay 0.1
	corfu-auto-prefix 2
	global-corfu-modes '((not
			       erc-mode
			       circe-mode
			       help-mode
			       gud-mode
			       vterm-mode)
			       t)
	corfu-cycle t
	corfu-separator ?\s
	corfu-preselect 'valid
	corfu-count 16
	corfu-max-width 120
	corfu-preview-current 'insert
	corfu-on-exact-match nil
	corfu-quit-at-boundary 'separator
	corfu-quit-no-match 'separator)
    (add-hook! 'minibuffer-setup-hook
    (defun +corfu-enable-in-minibuffer ()
      "Enable Corfu in the minibuffer if `completion-at-point' is bound."
      (when (where-is-internal #'completion-at-point (list (current-local-map)))
        (setq-local corfu-echo-delay nil)
        (corfu-mode +1))))

    (after! evil
	    (add-hook 'evil-insert-state-exit-hook #'corfu-quit))

    (after! orderless
	    (setq orderless-component-separator #'orderless-escapable-split-on-space)))

  (use-package! lsp-mode
    :custom
    (lsp-completion-provider :none)
    :init
    (defun my/lsp-mode-setup-completion ()
      (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
            '(orderless))) ;; Configure orderless
    :hook
    (lsp-completion-mode . my/lsp-mode-setup-completion))

  (use-package! orderless
    :init
    (setq completion-styles '(orderless partial-completion basic))
    (setq completion-category-defaults nil)
    (setq completion-category-overrides nil))

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

  (use-package! evil-collection-corfu
    :when (modulep! :editor evil +everywhere)
    :defer t
    :init (setq evil-collection-corfu-key-themes '(default magic-return))
    :config
    (evil-collection-corfu-setup))

  (defvar +corfu-global-capes
    '(:completion)
    "A list of global capes to be available at all times.
The key :completion is used to specify where completion candidates should be
placed, otherwise they come first.")

  (defvar +corfu-capf-hosts
    '(lsp-completion-at-point
      eglot-completion-at-point
      elisp-completion-at-point
      tags-completion-at-point-function)
    "A prioritised list of host capfs to create a super cape onto from
  `+corfu-global-capes'.")

  (use-package! cape
  :defer t
  :init
  (add-hook! prog-mode
    (defun +corfu-add-cape-file-h ()
      (add-hook 'completion-at-point-functions #'cape-file -10 t)))
  (add-hook! (org-mode markdown-mode)
    (defun +corfu-add-cape-elisp-block-h ()
      (add-hook 'completion-at-point-functions #'cape-elisp-block 0 t)))
  ;; Enable Dabbrev completion basically everywhere as a fallback.
  (when (modulep! +dabbrev)
    ;; Set up `cape-dabbrev' options.
    (defun +dabbrev-friend-buffer-p (other-buffer)
      (< (buffer-size other-buffer) +corfu-buffer-scanning-size-limit))
    (after! dabbrev
      (setq cape-dabbrev-check-other-buffers t
            dabbrev-friend-buffer-function #'+dabbrev-friend-buffer-p
            dabbrev-ignored-buffer-regexps
            '("^ "
              "\\(TAGS\\|tags\\|ETAGS\\|etags\\|GTAGS\\|GRTAGS\\|GPATH\\)\\(<[0-9]+>\\)?")
            dabbrev-upcase-means-case-search t)
      (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)

      (add-hook! (prog-mode text-mode conf-mode comint-mode minibuffer-setup
                            eshell-mode)
        (defun +corfu-add-cape-dabbrev-h ()
          (add-hook 'completion-at-point-functions #'cape-dabbrev 20 t)))))
  ;; Complete emojis :).
  (when (and (modulep! +emoji) (> emacs-major-version 28))
    (add-hook! (prog-mode conf-mode)
      (defun +corfu-add-cape-emoji-h ()
        (add-hook 'completion-at-point-functions
                  (cape-capf-inside-faces
                   (cape-capf-prefix-length #'cape-emoji 1)
                   ;; Only call inside comments and docstrings.
                   'tree-sitter-hl-face:doc 'font-lock-doc-face
                   'font-lock-comment-face 'tree-sitter-hl-face:comment)
                  10 t)))
    (add-hook! text-mode
      (defun +corfu-add-cape-emoji-text-h ()
        (add-hook 'completion-at-point-functions
                  (cape-capf-prefix-length #'cape-emoji 1) 10 t))))
  ;; Enable dictionary-based autocompletion.
  (when (modulep! +dict)
    (add-hook! (prog-mode conf-mode)
      (defun +corfu-add-cape-dict-h ()
        (add-hook 'completion-at-point-functions
                  (cape-capf-inside-faces
                   ;; Only call inside comments and docstrings.
                   #'cape-dict 'tree-sitter-hl-face:doc 'font-lock-doc-face
                   'font-lock-comment-face 'tree-sitter-hl-face:comment)
                  40 t)))
    (add-hook! text-mode
      (defun +corfu-add-cape-dict-text-h ()
        (add-hook 'completion-at-point-functions #'cape-dict 40 t))))

  ;; Make these capfs composable.
  (advice-add #'comint-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-nonexclusive)
  ;; From the `cape' readme. Without this, Eshell autocompletion is broken on
  ;; Emacs28.
  (when (< emacs-major-version 29)
    (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
    (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible))
