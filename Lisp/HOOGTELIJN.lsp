
(princ "\n Loading HOOGTELIJN")

(defun C:HOOGTELIJN (/ txt txtVal rVal)

  (setq txt (entsel "Selecteer de tekst met de hoogte: "))
  (if (= txt nul)
    (progn
      (princ "\n GEEN TEXT GESELECTEERD")
    )
    (progn
      (setq txtVal (cdr (assoc 1 (entget (car txt)))))
      (setq rVal (atof txtVal))
      (setq rVal (* (- (* 1000 rVal) 5000) 5))
      (princ (strcat "\n Hoogte = " (rtos rVal)))
      (princ "\n")
      (setq pntBegin (getpoint "Selecteer beginpunt lijn:"))
      (setq pntX (car pntbegin))
      (setq pntY (cadr pntbegin))
      (setq pntZ (caddr pntbegin))
      (setq pntEnd (list pntX (+ pntY rval) pntZ))
      (command "_LINE" pntBegin pntEnd "")
    )
  )
  (princ)
)

