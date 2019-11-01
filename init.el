;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(package-selected-packages (quote (treemacs ggtags))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

;; desde aqui, editado por mi
(package-initialize)

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)

(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Filtros de ibuffer
(setq ibuffer-saved-filter-groups
      '(("home"
	 ("Org" (mode . org-mode))
         ("C++" (mode . c++-mode))
	 ("C" (mode . c-mode))
	 ("Directorios" (mode . dired-mode))
	 )
	)
      )

;; Aplicar filtros
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-switch-to-saved-filter-groups "home")))

(global-set-key (kbd "C-t") 'eshell)

;; directorio de modulos
(add-to-list 'load-path "~/.emacs.d/custom/")

;; cargar modulos
 (require 'use-package)
 (require 'setup-applications)
 (require 'setup-communication)
 (require 'setup-convenience)
 (require 'setup-data)
 (require 'setup-development)
 (require 'setup-editing)
 (require 'setup-files)
 (require 'setup-environment)
 (require 'setup-external)
 (require 'setup-faces)
 
 (require 'setup-help)
 (require 'setup-programming)
 (require 'setup-text)
 (require 'setup-local)


(add-hook 'c-mode-common-hook
    (lambda ()
      (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
  (ggtags-mode 1))))


(add-hook 'dired-mode-hook 'ggtags-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-python-flake8-executable "python3")
 '(flycheck-python-pycompile-executable "python3")
 '(flycheck-python-pylint-executable "python3")
 '(initial-buffer-choice (quote treemacs))
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (exec-path-from-shell flycheck-pos-tip flycheck yasnippet-snippets yasnippet undo-tree volatile-highlights smartparens fancy-battery nyan-mode golden-ratio doom-modeline treemacs-projectile doom-themes treemacs use-package ggtags))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
