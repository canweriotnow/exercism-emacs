;;; ex-util.el --- Utility functions for exercism.el

;;; Commentary:

;;; Code:

(require 'json)

(defun buffer-mode (&optional buffer-or-name)
  "Return the major mode associated with current buffer or BUFFER-OR-NAME."
  (buffer-local-value 'major-mode
                      (if buffer-or-name
                          (get-buffer buffer-or-name)
                        (current-buffer))))


(defun load-json-config (&optional exercism-config)
  "Read exercism JSON config from default location or EXERCISM-CONFIG."
  (let ((config-file (or exercism-config "~/.exercism.json"))
        (json-object-type 'hash-table))
    (json-read-file config-file)))

(provide 'ex-util)
;;; ex-util.el ends here
