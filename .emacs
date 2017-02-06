;; Link file in windows: cmd /c "mklink C:\Users\hust921\.emacs C:\Users\hust921\dotfiles\.emacs"
;; Install key-chord "manually"
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (ggtags evil-magit magit color-theme flymode key-chord keychord use-package evil-visual-mark-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Custom
;; The major default settings for enviroment
;; and package syncronyzation
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Enviroment

;; ___________END OF MAJOR___________ ;;

;; EVIL mode (vim)
(use-package evil
  :ensure t)
(evil-mode t)

  ;; Rebinding <ESC> to jk
  (require 'key-chord)
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
  (key-chord-mode 1)

;; CtrlP for emacs (kinda)
(use-package ido
  :ensure t)
(ido-mode t)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)

;; Latex
(use-package tex
  :defer t
  :ensure auctex
  :config
    (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (setq TeX-save-query t)
    (setq TeX-PDF-mode t)
)

;; Sytax Checking (on the fly)
(use-package flymake
  :ensure t)
(defun flymake-get-tex-args (file-name)
  (list "pdflatex"
  (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))

;; Visual (Color Theme, for now)
(use-package color-theme
  :ensure t)
(color-theme-initialize)
(color-theme-gray30)

;; Git
(use-package magit
  :ensure t)
(use-package evil-magit
  :ensure t)

;; C-Completion
(use-package ggtags
  :ensure t)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

;; ___________OS SPECIFIC___________ ;;
(if (eq system-type 'ms-dos)

  ;; ____WINDOWS____
  (progn
    ;; Set eshell & shell
    (make-comint-in-buffer "cmd" nil "cmd" nil)
  )

  ;; ____LINUX____
  (progn

  )
)
;; ___________END OF OS SPECIFIC___________ ;;
