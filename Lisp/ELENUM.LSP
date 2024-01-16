
(DEFUN C:eleNUM	(/ AS OS E N L P ST NR)

  (SETQ NR (GETINT "\nStartwaarde ? <1> "))
  (SETQ ST (GETINT "\nIncrement <1>? "))
  (SETQ VL (GETSTRING "\nGeef voorletter element "))
  (IF (= NR nil)
    (SETQ NR 1)
  )
  (IF (= VL nil)
    (SETQ VL "B")
  )
  (IF (= ST nil)
    (SETQ ST 1)
  )
  (SETQ P (SSGET))
  (IF P
    (PROGN
      (SETQ L 0
	    N (SSLENGTH P)
      )
      (WHILE (< L N)
	(IF (= "TEXT" (CDR (ASSOC 0 (SETQ E (ENTGET (SSNAME P L))))))
	  (PROGN
	    (SETQ OS (CDR (SETQ AS (ASSOC 1 E))))
	    (SETQ E (SUBST (CONS 1 (strcat VL (ITOA NR))) AS E))
	    (ENTMOD E)
	    (SETQ NR (+ NR ST))
	  )
	)
	(IF (= "INSERT" (CDR (ASSOC 0 (SETQ E (ENTGET (SSNAME P L))))))
	  (PROGN
	    (SETQ PNT (CDR (ASSOC 10 (ENTGET (SSNAME P L)))))
	    (COMMAND "ATTEDIT"
		     "Y"
		     "*"
		     "*"
		     "*"
		     PNT
		     ""
		     "V"
		     "R"
		     (strcat VL (ITOA NR))
		     ""
	    )
	    (SETQ NR (+ NR ST))
	  )
	)
	(SETQ L (1+ L))
      )
    )
  )
  (TERPRI)
  (setq p nil)
  (princ)
)
