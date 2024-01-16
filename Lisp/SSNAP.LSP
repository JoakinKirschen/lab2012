
(DEFUN C:ssnap ()

  (SETQ pt1 (GETPOINT "\n Duid beginpunt aan van lijn : "))
  (SETQ pt2 (GETPOINT "\n Duid eindpunt aan van lijn : "))
  (SETQ hoek (angle pt1 pt2))
  (SETQ hoek1 (/ (* 180 hoek) PI))
  (COMMAND "snap" "R" "0,0" hoek1 "")
  princ
)
