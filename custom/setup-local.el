
;;This sets $MANPATH, $PATH and exec-path from your shell, but only on OS X and Linux.

(require 'exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(provide 'setup-local)
