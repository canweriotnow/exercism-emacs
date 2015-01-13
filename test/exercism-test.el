;;; exercism-test --- test suite for exercism.el

;;; Commentary:

;;; Code:

(load-file "exercism.el")

(ert-deftest is-true ()
  (should (eq t t)))



(provide 'exercism-test)

;;; exercism-test.el ends here
