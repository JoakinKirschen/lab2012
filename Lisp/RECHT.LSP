
(DEFUN C:recht ()

  (SETQ begin (GETPOINT "\n Geef beginpunt van rechthoek : "))
  (SETQ breedte (GETREAL "\n Geef de breedte in : "))
  (SETQ hoogte (GETREAL "\n Geef de hoogte in : "))
  (SETQ antw (GETSTRING "\n Polyline (P) of Line (L) ?"))
  (SETQ x1 (car begin))
  (SETQ y1 (cadr begin))
  (IF (= antw "P")
    (COMMAND "PLINE"
	     begin
	     (LIST x1 (+ y1 hoogte))
	     (LIST (+ x1 breedte) (+ y1 hoogte))
	     (LIST (+ x1 breedte) y1)
	     begin
	     ""
    )
    (IF	(= antw "p")
      (COMMAND "PLINE"
	       begin
	       (LIST x1 (+ y1 hoogte))
	       (LIST (+ x1 breedte) (+ y1 hoogte))
	       (LIST (+ x1 breedte) y1)
	       begin
	       ""
      )
      (COMMAND "LINE"
	       begin
	       (LIST x1 (+ y1 hoogte))
	       (LIST (+ x1 breedte) (+ y1 hoogte))
	       (LIST (+ x1 breedte) y1)
	       begin
	       ""
      )
    )
  )
)
