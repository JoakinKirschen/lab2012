
(defun C:movedwg ()

  (setq cIpt (getvar "UCSORG"))
  (setq nIpt (list 0.0 0.0 0.0))
  (if (> (distance cIpt nIpt) 0.000001)
    (progn
      (command "._Ucs" "_World")
      (Command "._Move" "_All" "" cIpt nIpt)
      (command "._Ucs" "_Z" "180")
      (Command "._Zoom" "_E")
    )
  )
  (princ)
)
