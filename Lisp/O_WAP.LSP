
(DEFUN C:o_wap ()
  (setq c1 (getvar "clayer"))
  (SETQ begin (GETPOINT "\n Geef beginpunt van de staaf : "))
  (SETQ einde (GETPOINT "\n Geef eindpunt van de staaf : "))
  (SETQ x1 (car begin))
  (SETQ y1 (cadr begin))
  (SETQ x2 (car einde))
  (SETQ y2 (cadr einde))
  (COMMAND "LAYER" "S" "S-4000-ONDERWAP" "")
  (IF (= y1 y2)
    (COMMAND "LINE"
	     (LIST (+ x1 50) (+ y1 50))
	     (LIST (- x2 50) (+ y2 50))
	     ""
    )
    (IF	(= x1 x2)
      (COMMAND "LINE"
	       (LIST (+ x1 50) (+ y1 50))
	       (LIST (+ x2 50) (- y2 50))
	       ""
      )
    )
  )
  (command "LAYER" "s" c1 "")
)
