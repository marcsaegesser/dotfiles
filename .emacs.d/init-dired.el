(require-package 'dired+)

(eval-after-load 'dired
  '(progn
     (require 'dired+)
     (setq dired-recursive-deletes 'top)
     (define-key dired-mode-map [mouse-2] 'dired-find-file)))

(diredp-toggle-find-file-reuse-dir 1)

(provide 'init-dired)
