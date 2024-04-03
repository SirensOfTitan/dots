(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(safe-local-variable-values
   '((eval progn
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
