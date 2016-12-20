;;; ex-request.el --- Exercism API request functions

;;; Commentary:

;;; Code:

(require 'url)
(require 'json)
(require 'request)
(require 'ht)
(require 'dash)

(defvar user-agent "exercism.el")



(defvar api-host "http://exercism.io")
(defvar x-api-host "http://x.exercism.io")
(defvar api-key nil)

(defun ex-get* (endpoint)
  "Get ENDPOINT in a generic fashion."
  (request
   endpoint
   :parser (lambda ()
             (let ((json-object-type 'hash-table))
               (json-read)))))


(provide 'ex-request)
;;; ex-request.el ends here
