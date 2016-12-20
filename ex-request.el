;;; ex-request.el --- Exercism API request functions

;;; Commentary:

;;; Code:

(require 'url)
(require 'json)
(require 'request)

(defvar user-agent "exercism.el")

(defvar api-host nil)
(defvar x-api-host nil)
(defvar api-key nil)




(provide 'ex-request)
;;; ex-request.el ends here
