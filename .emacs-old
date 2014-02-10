;;; XEmacs backwards compatibility file
(add-to-list 'load-path "~/bin/scala-tool-support/emacs")
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/icicles")
(add-to-list 'load-path "~/bin")
(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/haskell-mode")

(add-to-list 'load-path "~/bin/ensime_2.9.2-0.9.8.1/elisp")
(require `ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(setq inhibit-startup-message t)

(setq truncate-lines t)

(require 'smooth-scrolling)
(setq smooth-scroll-margin 1)
(setq smooth-scroll-lines-from-window-top 1)
(setq smooth-scroll-from-window-bottom 1)

(global-set-key "\C-u" 'scroll-down)

(defun gcm-scroll-down ()
  (interactive)
  (scroll-up 1))

(defun gcm-scroll-up ()
  (interactive)
  (scroll-down 1))

(global-set-key "\C-\M-n" 'gcm-scroll-down)
(global-set-key "\C-\M-p" 'gcm-scroll-up)

(global-set-key (kbd "C-S-n") 'next-buffer)
(global-set-key (kbd "C-S-p") 'previous-buffer)

(require 'prev-next-buffer)
(require 'icicles)

;(setq user-init-file
;      (expand-file-name "init.el"
;			(expand-file-name ".xemacs" "~")))
;(setq custom-file
;      (expand-file-name "custom.el"
;			(expand-file-name ".xemacs" "~")))
;
;(load-file user-init-file)
;(load-file custom-file)

(require 'scala-mode-auto)

(defun scala-turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))

(add-hook 'scala-mode-hook 'scala-turn-off-indent-tabs-mode)

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t) 
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

(require 'rainbow-delimiters)
(require 'clojure-mode)
(require 'paredit)
(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(load "haskell-site-file")

(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(add-to-list 'same-window-buffer-names "*nrepl*")

;(icy-mode)
;(setq iswitchb-buffer-ignore '("^ " "*Buffer"))

;(if (window-system)
;	(set-frame-size (selected-frame) 124 80))

;;(setq default-frame-alist
;;      '((top . 0) (left . 700)
;;        (width . 180) (height . 300)
;;        (cursor-color . "black")
;;        (cursor-type . box)
;;        (foreground-color . "black")
;;        (background-color . "white")
;;        (font . "-*-Lucida Console-normal-r-*-*-9-*-*-*-c-*-iso8859-1")))

(setq default-frame-alist
      '((top . 0) (left . 700)
        (width . 180) (height . 300)
        (cursor-color . "black")
        (cursor-type . box)
        (foreground-color . "black")
        (background-color . "white")))

(setq initial-frame-alist '((top . 0) (left . 700) (width . 200) (height . 100)))

(server-start)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 90 :width normal)))))
