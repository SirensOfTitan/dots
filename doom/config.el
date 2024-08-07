;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(defvar header-font nil)

(defun safe-local-variable-p (sym val)
  t)

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
(setq org-directory "~/Library/Mobile Documents/com~apple~CloudDocs/org")

(after! org-agenda
  (setq org-agenda-files (list org-directory (concat org-directory "/roam") (concat org-directory "/roam/daily")))
  (setq org-agenda-custom-commands
        '(("w" "Function Health TODO items"
           ((org-ql-block '(and (todo "TODO")
                                (tags "FUNCTION"))
                          ((org-ql-block-header "Function TODOs")))))
          ("p" "Personal TODO items"
           ((org-ql-block '(and (todo "TODO")
                                (not (tags "FUNCTION")))
                          ((org-ql-block-header "Personal TODOs"))))))))

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

;; (use-package! deadgrep
;;   :if (executable-find "rg")
;;   :init
;;   (map! "M-s" #'deadgrep))

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

;; (use-package! org-anki
;;   :config
;;   (setq org-anki-default-deck "General")
;;   (setq org-anki-default-match "+anki"))

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config (setq org-modern-star 'replace))

;; (use-package! mixed-pitch
;;   :hook (org-mode . mixed-pitch-mode)
;;   :config
;;   (pushnew! mixed-pitch-fixed-pitch-faces
;;             'org-date
;;             'org-special-keyword
;;             'org-property-value
;;             'org-drawer
;;             'org-ref-cite-face
;;             'org-tag
;;             'org-todo-keyword-todo
;;             'org-todo-keyword-habt
;;             'org-todo-keyword-done
;;             'org-todo-keyword-wait
;;             'org-todo-keyword-kill
;;             'org-todo-keyword-outd
;;             'org-todo
;;             'org-done
;;             'font-lock-comment-face
;;             'line-number
;;             'line-number-current-line))

;; Set org faces

(use-package! magit-delta
  :after magit
  :if (executable-find "delta"))

;; (with-eval-after-load 'org-superstar
;;   (set-face-attribute 'org-superstar-header-bullet nil :height 1.1)
;;   (set-face-attribute 'org-superstar-item nil :height 2.0)
;;   (set-face-attribute 'org-superstar-leading nil :height 0.5))

(use-package! dired
  :hook (dired-mode . dired-omit-mode)
  :config
  (setq dired-omit-files "^\\.[^.].*$"))

(use-package! org
  :hook ((org-mode . olivetti-mode)
         (org-mode . doom-disable-line-numbers-h))
  :config
  (setq org-adapt-indentation nil)
  (setq org-indent-indentation-per-level 1)
  (setq org-hide-emphasis-markers t)
  (setq org-default-notes-file (concat org-directory "inbox.org"))
  (setq org-catch-invisible-edits 'show-and-error)
  (setq org-auto-align-tags nil)
  (setq org-tags-column 0)
  (setq org-catch-invisible-edits 'show-and-error)
  (setq org-pretty-entities t)
  (setq org-ellipsis "…")
  (setq org-reverse-note-order t))

(after! org (add-to-list 'org-modules 'org-habit t))
(setq org-journal-file-type 'monthly)

;; (add-hook 'org-mode-hook #'org-appear-mode)

;; (add-hook 'org-mode-hook #'doom-disable-line-numbers-h)

(after! org
  (setq org-attach-dir-relative t))

(use-package! org-transclusion
  :hook (org-mode-hook . org-transclusion-mode)
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


(use-package! org-roam
  :init
  (map!
   :leader
   :prefix "n r"
   :desc "Capture random prompt in daily" "p" #'colep/org-roam-capture-prompt-in-daily))


(defun colep/org-roam-capture-prompt-in-daily ()
  "Capture a prompt in today's daily note."
  (interactive)
  (org-roam-dailies-capture-today nil "p"))

(defun colep/org-roam-prompt-template ()
  (let* ((prompts (org-roam-db-query [:select [nodes:title, nodes:id]
                                      :from nodes
                                      :inner-join tags
                                      :on (= tags:node-id nodes:id)
                                      :where (= tags:tag "prompt")]))
         (random-prompt (nth (random (length prompts)) prompts)))
    (message "test stuff %s %s" prompts (length prompts))
    (concat (format "* Prompt\n#+transclude: [[id:%s][%s]] :exclude-elements \"drawer title filetags\" :disable-auto\n** Response\n"
                    (nth 0 (cdr random-prompt))
                    (car random-prompt))
            "%?")))

(after! org-roam
  (setq org-roam-dailies-capture-templates
        '(("d" "[D]efault" entry "* %?" :target
           (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
          ("w" "[W]ork todo" entry "* TODO %? :FUNCTION:" :target
           (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
          ("t" "Personal [t]odo" entry "* TODO %? :PERSONAL:" :target
           (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
          ("b" "[B]ookmark" entry
           "* [[%^{link-url}][%^{link-description}]] :BOOKMARK:" :target
           (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
          ("p" "prompt" entry (function (lambda (&rest _) (colep/org-roam-prompt-template))) :target
           (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))))

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
         +corfu-want-minibuffer-completion nil
         corfu-max-width 70))

;; (setq-hook! 'python-mode-hook +format-with '+format-with-lsp-fn)

;; (after! lsp-mode
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-stdio-connection (lambda () "lsp-ai"))
;;                     :major-modes '(nix-mode rustic-mode clojure-mode)
;;                     :server-id 'lsp-ai
;;                     :add-on? t
;;                     :initialization-options
;;                     (lambda () (append
;;                                 `(:models (:model1 (:type "open_ai"
;;                                                     :chat_endpoint "https://api.groq.com/openai/v1/chat/completions"
;;                                                     :model "llama3-70b-8192"
;;                                                     :auth_token_env_var_name "GROQ_API_KEY")))
;;                                 `(:memory (:file_store {}))
;;                                 `(:completion (:model "model1"
;;                                                :parameters (:max_tokens 128
;;                                                             :max_context 4096
;;                                                             :messages ((:role "system"
;;                                                                         :content "Instructions:\n- You are an AI programming assistant.\n- Given a piece of code with the cursor location marked by \"<CURSOR>\", replace \"<CURSOR>\" with the correct code or comment.\n- First, think step-by-step.\n- Describe your plan for what to build in pseudocode, written out in great detail.\n- Then output the code replacing the \"<CURSOR>\"\n- Ensure that your completion fits within the language context of the provided code snippet (e.g., Python, JavaScript, Rust).\n\nRules:\n- Only respond with code or comments.\n- Only replace \"<CURSOR>\"; do not include any previously written code.\n- Never include \"<CURSOR>\" in your response\n- If the cursor is within a comment, complete the comment meaningfully.\n- Handle ambiguous cases by providing the most contextually appropriate completion.\n- Be consistent with your responses.")
;;                                                                        (:role "user"
;;                                                                         :content "def greet(name):\n    print(f\"Hello, {<CURSOR>}\")")
;;                                                                        (:role "assistant"
;;                                                                         :content "name")
;;                                                                        (:role "user"
;;                                                                         :content "function sum(a, b) {\n    return a + <CURSOR>;\n}")
;;                                                                        (:role "assistant"
;;                                                                         :content "b")
;;                                                                        (:role "user"
;;                                                                         :content "fn multiply(a: i32, b: i32) -> i32 {\n    a * <CURSOR>\n}")
;;                                                                        (:role "assistant"
;;                                                                         :content "b")
;;                                                                        (:role "user"
;;                                                                         :content "# <CURSOR>\ndef add(a, b):\n    return a + b")
;;                                                                        (:role "assistant"
;;                                                                         :content "Adds two numbers")
;;                                                                        (:role "user"
;;                                                                         :content "# This function checks if a number is even\n<CURSOR>")
;;                                                                        (:role "assistant"
;;                                                                         :content "def is_even(n):\n    return n % 2 == 0")
;;                                                                        (:role "user"
;;                                                                         :content "{CODE}"))))))))))
(use-package! envrc
  :hook (after-init . envrc-global-mode))

(add-to-list 'treesit-language-source-alist
             '(typst "https://github.com/uben0/tree-sitter-typst"))
(treesit-install-language-grammar 'typst)
