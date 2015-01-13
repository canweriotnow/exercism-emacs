;;; exercism.el - interact with exercism.io from within emacs

;; Author: Jason Lewis
;; URL:
;; Created 2015.01.12
;; Version: 0.0.1

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

(require 'cl)
(require 'url)
(require 'json)

;;; Utility functions
(defun get-string-from-file (file-path)
  "Reads a file into a string."
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun get-exercism-config (file-path)
  "Parses exercism json config into a plist."
  (let ((json-object-type 'plist)
        (json-string (get-string-from-file file-path)))
    (json-read-from-string json-string)))

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
  "Local alias symbols that expand to namespace"
  `(let) body)

;(defconst exercism-base-url "http://exercism.io"
;  "endpoint to submit solutions to, and to get personalized data")

;(defconst exercism-fetch-url "http://x.exercism.io"
;  "endpoint to fetch problems from")

(defvar *exercism-current-exercise*)

(defvar *exercism-config*
  (get-exercism-config "~/.exercism.json"))

;(dired (plist-get *exercism-config* :dir))



;;;;; Interactive User Funs

;;;###autoload
(defun exercism ()
  "Open the user's exercism directory in dired-mode"
  (interactive)
  (let ((exercism-dir (plist-get *exercism-config* :dir)))
    (dired exercism-dir)))


;;;###autoload
(defun exercism-submit ()
  (interactive)
  (let ((exercise buffer-file-name)
          (cmd (shell-command-to-string "which exercism")))
      (if (zerop (length cmd))
          "exercism not found"
        (shell-command-to-string (concat "exercism submit " exercise)))))

;;;###autoload
(defun exercism-fetch ()
  (interactive)
  (let ((cmd (shell-command-to-string "which exercism")))
    (if (zerop (length cmd))
        "exercism not found"
      (shell-command-to-string (concat cmd " fetch")))))


(defun exercism-path-p
    (string-match-p "/exercism/"
                    (or (buffer-file-name) default-directory)))

;;; Utility functions







;;;

(provide 'exercism)

;;; exercism.el ends here
