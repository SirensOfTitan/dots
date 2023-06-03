;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(defvar header-font nil)

;; (setq-hook! 'js2-mode-hook +format-with-lsp t)
;; (setq-hook! 'rjsx-mode-hook +format-with-lsp t)
;; (setq-hook! 'typescript-tsx-mode +format-with-lsp t)
(setq-hook! 'js-mode-hook +format-with-lsp nil)
(setq-hook! 'js-mode-hook +format-with 'prettier)
(setq-hook! 'typescript-tsx-mode +format-with-lsp nil)
(setq-hook! 'typescript-tsx-mode +format-with 'prettier)

(setq leuven-scale-org-agenda-structure nil)
(setq leuven-scale-volatile-highlight nil)
(setq leuven-scale-outline-headlines nil)
;; Annoying when using org-roam
(setq auto-save-default nil)
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Cole Potrocky"
      user-mail-address "cole@potrocky.com"
      doom-theme 'doom-flatwhite        ; Fave light theme
      ;doom-theme 'doom-city-lights      ; Fave dark theme
      doom-font (font-spec :family "Iosevka Raisa Medium" :size 16))
      ;doom-big-font (font-spec :family "Inter")
      ;header-font (font-spec :family "Inter" :size 15)
      ;doom-variable-pitch-font (font-spec :family "Besley*" :size 15)
      ;doom-serif-font (font-spec :family "Besley*"))
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
(setq org-directory "~/Brain/")

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
(add-hook 'org-mode-hook 'olivetti-mode)

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


(use-package! org-roam-protocol
  :after org-protocol)
(setq enable-local-variables t)

;; (use-package! org-roam-server
;;   :config
;;   (setq org-roam-server-host "127.0.0.1"
;;         org-roam-server-port 8080
;;         org-roam-server-authenticate nil
;;         org-roam-server-export-inline-images t
;;         org-roam-server-serve-files nil
;;         org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;         org-roam-server-network-poll t
;;         org-roam-server-network-arrows nil
;;         org-roam-server-network-label-truncate t
;;         org-roam-server-network-label-truncate-length 60
;;         org-roam-server-network-label-wrap-length 20))

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

(use-package! company
  :config
  ;; (setq company-idle-delay nil)
  )

(use-package! company-posframe
  :hook (company-mode . company-posframe-mode))

(setq auth-sources '("~/.authinfo.gpg"))

(defun my-fetch-password (&rest params)
  (require 'auth-source)
  (let ((match (car (apply #'auth-source-search params))))
    (if match
        (let ((secret (plist-get match :secret)))
          (if (functionp secret)
              (funcall secret)
            secret))
      (error "Password not found for %S" params))))

(defun my-nickserv-password (server)
  (my-fetch-password :user "colep" :host "irc.libera.chat"))

(after! circe
  (set-irc-server! "irc.libera.chat"
                   `(:tls t
                     :port 6697
                     :nick "colep"
                     :sasl-password my-nickserver-password)))

(setq-hook! 'web-mode-hook +format-with 'prettier-prettify)

(use-package! fancy-dabbrev
  :hook
  (after-init . global-fancy-dabbrev-mode)
  :bind (("C-<enter>" . fancy-dabbrev-expand)))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (org-mode . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package! anki-editor
  :after org
  :config
  (setq anki-editor-create-decks t))

;; (use-package! org-visual-outline
;;   :hook (org-mode . org-dynamic-bullets-mode))

(map! :localleader
      :map org-mode-map
      (:prefix ("a" . "Anki")
       :desc "Push" "p" 'anki-editor-push-notes
       :desc "Retry" "r" 'anki-editor-retry-failure-notes
       :desc "New note" "n" 'anki-editor-insert-note
       :desc "Cloze dwim" "d" 'anki-editor-cloze-dwim
       :desc "Cloze region" "r" 'anki-editor-cloze-region))

(use-package! latex-preview-pane
  :config
  (setq pdf-latex-command "xelatex"))

(use-package! lsp-sourcekit
  :after lsp-mode
  :config
  (setq lsp-sourcekit-executable (string-trim (shell-command-to-string "xcrun --find sourcekit-lsp"))))

;; Blocked until m1 support lands for tree-sitter binary.
(use-package! tree-sitter
  :hook
  (prog-mode . global-tree-sitter-mode)
  :config
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

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
(setq auth-sources '("~/.authinfo"))
(after! forge
  (add-to-list 'forge-alist '("git@gitlab.rebellion.dev" "gitlab.rebellion.dev/api/v4" "gitlab.rebellion.dev" forge-gitlab-repository))
  (add-to-list 'forge-alist '("git@git.tools.rebellion.dev" "api.git.tools.rebellion.dev" "git.tools.rebellion.dev" forge-github-repository)))

(add-hook 'code-review-mode-hook
          (lambda ()
            ;; include *Code-Review* buffer into current workspace
            (persp-add-buffer (current-buffer))))

(after! magit
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))
(setq code-review-github-host "api.git.tools.rebellion.dev/v3")
(setq code-review-github-graphql-host "api.git.tools.rebellion.dev")
(setq code-review-github-base-url "git.tools.rebellion.dev")

(advice-add #'add-node-modules-path :override #'ignore)
