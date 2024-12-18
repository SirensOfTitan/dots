;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")

(package! kaolin-themes)
(package! graphql-mode)
                                        ;(package! deadgrep)
(package! magit-delta
  :recipe (:host github :repo "dandavison/magit-delta" :branch "master"))
(package! git-auto-commit-mode
  :recipe (:host github :repo "ryuslash/git-auto-commit-mode"))
(package! prism
  :recipe (:host github :repo "alphapapa/prism.el"))
;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)
(package! org-dynamic-bullets
  :recipe (:host github
           :repo "legalnonsense/org-visual-outline"
           :branch "master"
           :files ("*.el")))

(package! ultra-scroll-mac
  :recipe (:host github
           :repo "jdtsmith/ultra-scroll-mac"
           :branch "main"))

(package! prisma-mode :recipe (:host github :repo "pimeys/emacs-prisma-mode" :branch "main"))
(package! latex-preview-pane)
(package! ox-hugo)
;; (package! python-black)
(package! org-modern)

(package! mermaid-mode :recipe (:host github :repo "abrochard/mermaid-mode" :branch "master"))
(when (featurep! :lang org)
  (package! ob-mermaid))

(when (featurep! :editor evil +everywhere)
  (package! evil-textobj-tree-sitter))

                                        ;(package! closql :pin "0a7226331ff1f96142199915c0ac7940bac4afdd")

(package! olivetti
  :recipe (:host github
           :repo "rnkn/olivetti"
           :branch "master"))

(package! difftastic)

(package! org-ql :recipe (:host github
                          :repo "alphapapa/org-ql"
                          :branch "master"))
(package! gh-notify
  :recipe (:host github
           :repo "anticomputer/gh-notify"
           :branch "main"))
(package! babashka :recipe (:host github
                            :repo "licht1stein/babashka.el"
                            :branch "master"))

(package! jinja2-mode :recipe (:host github
                               :repo "paradoxxxzero/jinja2-mode"
                               :branch "master"))
(package! nix-update-el
  :recipe (:host github
           :repo "jwiegley/nix-update-el"
           :branch "master"))

(package! deadgrep :recipe (:host github
                            :repo "Wilfred/deadgrep"
                            :branch "master"))
(package! envrc :recipe (:host github
                         :repo "purcell/envrc"
                         :branch "master"))

(package! typst-ts-mode
  :recipe (:host sourcehut
           :repo "meow_king/typst-ts-mode"
           :branch "main"))

(package! lsp-biome
  :recipe (:host github
           :repo "cxa/lsp-biome"
           :files ("lsp-biome.el")
           :branch "main"))
