;;; exercism.el --- interact with exercism.io from within emacs

;; Filename: exercism.el
;; Author: Jason Lewis <jason@decomplecting.org>
;; Maintainer: Jason Lewis <jason@decomplecting.org>
;; Homepage: https://github.com/canweriotnow/exercism-emacs
;; Created: 2015.01.12
;; Package-Version: 0.0.2
;; Keywords: exercism
;; Dependencies: '(url json)
;; Package-Requires: ((request "0.2.0"))

;; This file is not part of GNU Emacs

;; Copyright (C) 2015  Jason Lewis

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Exercism provides functions for interacting with exercises from
;; exercism.io, submitting completed exercises, and fetching new ones.
;; It aims to eventually integrate with exercism unit tests and (possibly?)
;; auto-submit work when all tests pass.

;; The goal is to port the exercism CLI client from Go to elisp, but I think
;; for this first iteration I might just try to shell out to the CLI to run
;; submit and fetch.

;;; Code:

(require 'url)
(require 'json)
(require 'request)

;;; Utility functions
(defun exercism-get-config (file-path)
  "Parse exercism json config from FILE-PATH into a plist."
  (let ((json-object-type 'plist))
    (json-read-file file-path)))

(defun exercism-verify-config ()
  "Verify that exercism is properly configured; if not, configure it."
  (if (file-readable-p exercism-config-file)
      (setq *exercism-config* (exercism-get-config exercism-config-file))
    (exercism-configure)))

;; DO NOT USE - I have no idea what I'm doing.
(defun exercism-configure ()
  "Configure exercism if it hasn't been configured via the API."
  (interactive
   (let ((api-key (read-string "Exercism API Key: " nil)))
     (list (region-beginning) (region-end) api-key))))

(defun exercism-api-request (type url data &optional headers &rest args)
  "Send request of type TYPE to exercism API URL with DATA.
Optionally add HEADERS and other ARGS."
  (request
   url
   :type type
   :data data
   :parser (lambda ()
             (let ((json-object-type 'plist))
               (json-read)))
   :headers headers
   :success
   (function* (lambda (&key data &allow-other-keys)
                (when data
                  (with-current-buffer (get-buffer-create "*exercism-data*")
                    (erase-buffer)
                    (insert data)
                    (pop-to-buffer (current-buffer))))))
   :error
   (function* (lambda (&key error-thrown &allow-other-keys&rest _)
                (message "Got error: %S" error-thrown)))
   :complete (lambda (&rest _) (message "Finished!"))
   :status-code '((400 . (lambda (&rest _) (message "Got 400.")))
                  (401 . (lambda (&rest _) (message "Got 401."))))))

;;;###autoload
(progn
  (defgroup exercism nil
    "Exercism.io"
    :group 'external)

  (defcustom exercism-api-key ""
    "API key found on the /account page of exercism"
    :group 'exercism
    :type 'string)

  (defcustom exercism-config-file "~/.exercism.json"
    "Custom location for exercism config file"
    :group 'exercism
    :type 'string)
  )



(defmacro namespace (ns-name symbols-to-namespace &rest body)
  "Local alias to namespace NS-NAME symbols SYMBOLS-TO-NAMESPACE on BODY."
  `(let) body)


(defvar *exercism-current-exercise*)

(defvar *exercism-cmd*
  (replace-regexp-in-string "\n$" ""
                            (shell-command-to-string "which exercism"))
  "Find the exercism CLI path and chomp the trailing newline.")

(defvar *exercism-config*
  (exercism-get-config exercism-config-file)
  "The exercism configuration file data.")

(defvar *exercism-fetch-endpoint*
  (url-encode-url (concat
                   (plist-get *exercism-config* :xapi)
                   "/v2/exercises"
                   "?key="
                   (plist-get *exercism-config* :apiKey)))
  "The endpoint for fetching new exercises.")

;; A lot more to this; see:
;; https://github.com/exercism/cli/blob/master/cmd/submit.go
;; https://github.com/exercism/cli/blob/master/api/api.go

(defvar *exercism-submit-endpoint*
  (url-encode-url (concat
                   (plist-get *exercism-config* :api)
                   "/api/v1/user/assignments" ))
  "The endpoint for submitting assignments.")

(defun execute-command (command &optional arg)
  "Execute the exercism CLI with the supplied COMMAND.
Optionally pass ARG, for a result."
  (let ((cmd *exercism-cmd*))
    (if (zerop (length cmd))
        (user-error "Exercism CLI not found")
      (shell-command-to-string
       (mapconcat #'identity (list cmd command arg) " ")))))


;;;;; Interactive User Funs

;;;###autoload
(defun exercism ()
  "Open the user's exercism directory in 'dired-mode'."
  (interactive)
  (let ((exercism-dir (plist-get *exercism-config* :dir)))
    (dired exercism-dir)))

;;;###autoload
(defun exercism-submit-fn ()
  "Submit the exercism exercise in the current buffer."
  (interactive)
  (let ((data (json-encode '(:key exercism-api-key
                                  :solution (buffer-substring-no-properties
                                             (point-min) (point-max))))))
    ))


;;;;; HOPEFULLY DEPRECATED SOON - CLI-WRAPPERS

;;;###autoload
(defun exercism-submit ()
  "Submit the exercism exercise in the current buffer."
  (interactive)
  (block nil
    (when (and (buffer-modified-p)
               (not (y-or-n-p "Buffer modified since last save.  Submit anyway? ")))
      (message "Exercism submission aborted.")
      (return))
    (let ((exercise buffer-file-name))
      (message "Result: %s" (execute-command "submit" exercise)))))

;;;###autoload
(defun exercism-unsubmit ()
  "Unsubmit the most recently submitted iteration."
  (interactive)
  (let ((exercise buffer-file-name))
    (message "Result: %s" (execute-command "unsubmit" exercise))))


;;;###autoload
(defun exercism-fetch ()
  "Fetch the next set of exercises from exercism.io."
  (interactive)
  (message "Result: %s" (execute-command "fetch")))

;;;###autoload
(defun exercism-fetch-language ()
  "Fetch the next set of exercises from exercism.io."
  (interactive)
  (let ((language (read-from-minibuffer "Language: ")))
    (message "Result: %s" (execute-command (format "fetch %s" language)))))

;;;###autoload ()
(defun exercism-tracks ()
  "Retrieve the listing of active and inactive exercism tracks into a temp buffer."
  (interactive)
  (with-output-to-temp-buffer "Exercism Tracks"
    (princ (execute-command "tracks"))))

;;;###autoload ()
(defun exercism-list ()
  "Retrieve the list of exercises in given track/language into a temp buffer."
  (interactive)
  (let ((language (read-from-minibuffer "Language: ")))
    (with-output-to-temp-buffer (format "exercism-list-%s" language)
      (princ (execute-command (format "list %s" language))))))

;;;###autoload ()
(defun exercism-open ()
  "Retrieve the list of exercises in given track/language into a temp buffer."
  (interactive)
  (let ((language (read-from-minibuffer "Language: "))
        (problem (read-from-minibuffer "Problem: ")))
    (execute-command (format "open %s %s" language problem))))


(provide 'exercism)
;;; exercism.el ends here
