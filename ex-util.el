;;; ex-util.el --- Utility functions for exercism.el

;;; Commentary:

;;; Code:

(defun buffer-mode (&optional buffer-or-name)
  "Return the major mode associated with current buffer or BUFFER-OR-NAME."
  (buffer-local-value 'major-mode
                      (if buffer-or-name
                          (get-buffer buffer-or-name)
                        (current-buffer))))



(provide 'ex-util)
;;; ex-util.el ends here
