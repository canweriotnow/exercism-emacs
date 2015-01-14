;;; exercism.el --- interact with exercism.io from within emacs

;; Filename: exercism.el
;; Author: Jason Lewis <jason@decomplecting.org>
;; URL: https://github.com/canweriotnow/exercism-emacs
;; Created 2015.01.12
;; Version: 0.0.2
;; Dependencies: '(url json)

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

;; Exercism mode provides functions for interacting with exercises from
;; exercism.io, submitting completed exercises, and fetching new ones.
;; It aims to eventually integrate with exercism unit tests and (possibly?)
;; auto-submit work when all tests pass.

;; The goal is to port the exercism CLI client from Go to elisp, but I think
;; for this first iteration I might just try to shell out to the CLI to run
;; submit and fetch.

;;; Code:

(require 'url)
(require 'json)

;;; Utility functions
(defun exercism-get-config (file-path)
  "Parse exercism json config from FILE-PATH into a plist."
  (let ((json-object-type 'plist))
    (json-read-file file-path)))



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
  "Local alias symbols that expand to namespace."
  `(let) body)

;(defconst exercism-base-url "http://exercism.io"
;  "endpoint to submit solutions to, and to get personalized data")

;(defconst exercism-fetch-url "http://x.exercism.io"
;  "endpoint to fetch problems from")

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
                   "api/v1/user/assignments" ))
  "The endpoint for submitting assignments.")

(defun execute-command (command &optional arg)
  "Execute the exercism CLI with the supplied COMMAND.
Optionally pass ARG, for a result."
  (let ((cmd *exercism-cmd*))
    (if (zerop (length cmd))
        (user-error "Exercism CLI not found.")
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
(defun exercism-submit ()
  "Submit the exercism exercise in the current buffer."
  (interactive)
  (let ((exercise buffer-file-name))
    (message "Result: %s" (execute-command "submit" exercise))))

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

;;;###autoload ()
(defun exercism-tracks ()
  "Retrieve the listing of actie and inactive exercism tracks into a temp buffer."
  (interactive)
  (with-output-to-temp-buffer "Exercism Tracks"
    (princ (execute-command "tracks"))))



(provide 'exercism)
;;; exercism.el ends here
