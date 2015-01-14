;;; exercism-test --- test suite for exercism.el

;;; Commentary:

;;; Code:

(load-file "exercism.el")

;; Dummy
(ert-deftest is-true ()
  (should (eq t t)))

(ert-deftest is-nil ()
  (should (eq '() nil)))

(ert-deftest test-exercism-get-config ()
  (let ((config (exercism-get-config exercism-config-file)))
    (should (stringp (plist-get config :api)))
    (should (stringp (plist-get config :xapi)))
    (should (stringp (plist-get config :apiKey)))
    (should (stringp (plist-get config :dir)))))


(provide 'exercism-test)

;;; exercism-test.el ends here
