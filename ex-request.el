;;; ex-request.el --- Exercism API request functions

;;; Commentary:

;;; Code:

(require 'url)
(require 'json)
(require 'request)
(require 'ht)
(require 'dash)

(load-file "ex-util.el")
(require 'ex-util)



(defvar user-agent "exercism.el")

(defvar *config* (load-json-config))

(defvar api-host (ht-get *config* "api" "http://exercism.io"))
(defvar x-api-host (ht-get *config* "xapi" "http://x.exercism.io"))
(defvar api-key ht-get *config* "apiKey")




(defun ex-get* (endpoint )
  "Get ENDPOINT in a generic fashion."
  (request
   endpoint
   :params '(("key" . api-key))
   :parser (lambda ()
             (let ((json-object-type 'hash-table))
               (json-read)))))

(defun ex-get (endpoint)
  (request-response-status-code
   (ex-get* (format "%s/v2/exercises" endpoint))))

(ex-get x-api-host)



(provide 'ex-request)
;;; ex-request.el ends here
