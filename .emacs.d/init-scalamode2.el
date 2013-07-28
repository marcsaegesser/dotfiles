;;-----------------------------------------------------
;;Initialization for Scala-mode-2
;;-----------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/site-lisp/ensime/elisp")
;;(add-to-list 'load-path "~/.emacs.d/site-lisp/scamacs")
(require 'scala-mode2)
(require 'ensime)
;;(require 'ensime-ecb)

(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(defun scala-turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))

(add-hook 'scala-mode-hook 'scala-turn-off-indent-tabs-mode)

;;Scala-mode2 specific
(add-hook 'scala-mode-hook '(lambda ()

  ;; Bind the 'newline-and-indent' command to RET (aka 'enter'). This
  ;; is normally also available as C-j. The 'newline-and-indent'
  ;; command has the following functionality: 1) it removes trailing
  ;; whitespace from the current line, 2) it create a new line, and 3)
  ;; indents it.  An alternative is the
  ;; 'reindent-then-newline-and-indent' command.
  (local-set-key (kbd "RET") 'newline-and-indent)

  ;; Alternatively, bind the 'newline-and-indent' command and
  ;; 'scala-indent:insert-asterisk-on-multiline-comment' to RET in
  ;; order to get indentation and asterisk-insertion within multi-line
  ;; comments.
  ;; (local-set-key (kbd "RET") '(lambda ()
  ;;   (interactive)
  ;;   (newline-and-indent)
  ;;   (scala-indent:insert-asterisk-on-multiline-comment)))

  ;; Bind the 'join-line' command to C-M-j. This command is normally
  ;; bound to M-^ which is hard to access, especially on some European
  ;; keyboards. The 'join-line' command has the effect or joining the
  ;; current line with the previous while fixing whitespace at the
  ;; joint.
  (local-set-key (kbd "C-M-j") 'join-line)

  ;; Bind the backtab (shift tab) to
  ;; 'scala-indent:indent-with-reluctant-strategy command. This is usefull
  ;; when using the 'eager' mode by default and you want to "outdent" a
  ;; code line as a new statement.
  (local-set-key (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)

  ;; Bind F5 to launch debugger
  (local-set-key (kbd "<f5>") 'ensime-db-run)
  (local-set-key (kbd "<f7>") 'ensime-builder-rebuild)
  (local-set-key (kbd "C-<f7>") 'ensime-builder-build)

  ;; and other bindings here
))

(provide 'init-scalamode2)
