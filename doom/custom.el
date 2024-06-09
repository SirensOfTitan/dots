(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "9013233028d9798f901e5e8efb31841c24c12444d3b6e92580080505d56fd392" "f053f92735d6d238461da8512b9c071a5ce3b9d972501f7a5e6682a90bf29725" "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0" default))
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(safe-local-variable-values
   '((eval progn
      (setq lsp-ruff-lsp-ruff-args
       (vector
        (format "--config=%spyproject.toml"
                (locate-dominating-file ".git" "pyproject.toml"))))
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         (lambda nil lsp-ruff-lsp-server-command))
                        :activation-fn
                        (lsp-activate-on "python")
                        :server-id 'ruff-lsp :priority -2 :add-on? t :initialization-options
                        (lambda nil
                          (list :settings
                                (list :args lsp-ruff-lsp-ruff-args :format.args lsp-ruff-lsp-ruff-args :logLevel lsp-ruff-lsp-log-level :path lsp-ruff-lsp-ruff-path :interpreter
                                      (vector lsp-ruff-lsp-python-path)
                                      :showNotifications lsp-ruff-lsp-show-notifications :organizeImports
                                      (lsp-json-bool lsp-ruff-lsp-advertize-organize-imports)
                                      :fixAll
                                      (lsp-json-bool lsp-ruff-lsp-advertize-fix-all)
                                      :importStrategy lsp-ruff-lsp-import-strategy))))))
     (eval progn
      (setq lsp-ruff-lsp-ruff-args
            (vector
             (format "--config=%spyproject.toml"
                     (locate-dominating-file ".git" "pyproject.toml")))))
     (eval progn
      (setq lsp-ruff-lsp-ruff-args
            (vector
             (format "--config=%s/pyproject.toml"
                     (locate-dominating-file ".git" "pyproject.toml")))))
     (eval progn
      (print "hi"
             (locate-dominating-file default-directory ".git" "pyproject.toml"))
      (setq lsp-ruff-lsp-ruff-args
            (vector
             (format "--config=%s/pyproject.toml"
                     (locate-dominating-file default-directory ".git" "pyproject.toml")))))
     (eval progn
      (setq lsp-ruff-lsp-ruff-args
            (vector
             (format "--config=%s/pyproject.toml"
                     (locate-dominating-file default-directory ".git" "pyproject.toml")))))
     (eval progn
      (setq lsp-ruff-lsp-ruff-args
            (vector
             (format "--config=%s/pyproject.toml"
                     (vc-root-dir)))))
     (eval progn
      (setq lsp-ruff-lsp-ruff-args
            (vector
             (format "--config%spyproject.toml"
                     (vc-root-dir)))))
     (eval progn
      (print "hi")
      (setq lsp-ruff-lsp-ruff-args
            [(format "--config%spyproject.toml"
                     (vc-root-dir))]))
     (eval progn
      (setq lsp-ruff-lsp-ruff-args
            ["--config=./pyproject.toml"]))
     (eval progn
      (setq lsp-ruff-lsp-ruff-args
            ["--config ./pyproject.toml"]))
     (eval progn
      (require 'lsp)
      (lsp-register-custom-settings
       '(("ruff.format.args"
          ["--config ./pyproject.toml"])
         ("ruff.args" }
          ["--config ./pyproject.toml"])))
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("ruff-lsp"))
                        :server-id 'ruff-lsp :add-on? t :major-modes
                        '(python-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-custom-settings
       '(("ruff.format.args"
          ["--config ./pyproject.toml"])))
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("ruff-lsp"))
                        :server-id 'ruff-lsp :add-on? t :major-modes
                        '(python-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-custom-settings
       '(("ruff.format.args" "--config ./pyproject.toml")))
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("ruff-lsp"))
                        :server-id 'ruff-lsp :add-on? t :major-modes
                        '(python-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("ruff-lsp"))
                        :server-id 'ruff-lsp :add-on? t :major-modes
                        '(python-mode)))
      (lsp-register-custom-settings
       '(("ruff-lsp.format.args" "--config ./pyproject.toml"))))
     (eval progn
      (require 'lsp)
      (lsp-register-custom-settings
       '(("ruff-lsp.format.args" "--config ./pyproject.toml")))
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("ruff-lsp"))
                        :server-id 'ruff-lsp :add-on? t :major-modes
                        '(python-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-custom-settings
       '(("format.args" "--config ./pyproject.toml")))
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("ruff-lsp"))
                        :server-id 'ruff-lsp :add-on? t :major-modes
                        '(python-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("ruff-lsp"))
                        :server-id 'ruff-lsp :add-on? t :major-modes
                        '(python-mode))))
     (lsp-file-watch-ignored-directories "[/\\\\]\\.git$" "[/\\\\]\\.data$" "[/\\\\]\\.idea$" "[/\\\\]\\dist$" "[/\\\\]\\build$" "[/\\\\]\\build$" "[/\\\\]\\node_modules$" "[/\\\\]\\.direnv$" "[/\\\\]\\.cargo$" "[/\\\\]\\.direnv$" "[/\\\\]target$")
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("biome-lsp"))
                        :server-id 'biome-lsp :add-on? t :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode)))
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("relay-lsp"))
                        :server-id 'relay-lsp :add-on? t :major-modes
                        '(typescript-tsx-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("biome-lsp"))
                        :server-id 'biome-lsp :add-on? t :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (lsp-file-watch-ignored-directories "/\\.git$" "/\\.data$" "/\\.direnv$" "/target$")
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("biome-lsp"))
                        :server-id 'biome-lsp :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("biome-lsp"))
                        :server-id 'biome-lsp :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("biome-lsp"))
                        :server-id 'biome-lsp :root-dir
                        (file-name-directory
                         (buffer-file-name))
                        :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("bunx" "biome" "lsp-proxy"))
                        :server-id 'biome-lsp :root-dir
                        (file-name-directory
                         (buffer-file-name))
                        :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("bunx" "biome" "lsp-proxy"))
                        :server-id 'biome-lsp :root-dir "." :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("bunx" "biome" "lsp-proxy"))
                        :server-id 'biome-lsp :root-dir default-directory :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection
                         '("bunx" "biome" "lsp-proxy"))
                        :server-id 'biome-lsp :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval progn
      (require 'lsp)
      (lsp-register-client
       (make-lsp-client :new-connection
                        (lsp-stdio-connection "bunx biome lsp-proxy")
                        :major-modes
                        '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode))))
     (eval lsp-register-client
      (make-lsp-client :new-connection
                       (lsp-stdio-connection "bunx biome lsp-proxy")
                       :major-modes
                       '(typescript-tsx-mode typescript-mode javascript-mode json-mode css-mode)))
     (tags-table-list "./app" "./pulumi"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:family "Besley*" :weight semi-bold :height 1.3))))
 '(org-level-2 ((t (:family "Besley*" :weight semi-bold :height 1.1))))
 '(org-level-3 ((t (:family "Besley*" :weight semi-bold))))
 '(org-level-4 ((t (:family "Besley*" :weight medium))))
 '(org-level-5 ((t (:family "Besley*" :weight medium))))
 '(org-level-6 ((t (:family "Besley*" :weight medium))))
 '(org-level-7 ((t (:family "Besley*" :weight medium))))
 '(ts-fold-replacement-face ((t (:foreground unspecified :box nil :inherit font-lock-comment-face :weight light)))))
