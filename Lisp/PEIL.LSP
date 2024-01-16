
(DEFUN C:peil (/ A B X Y)
  
  (SETQ A (GETPOINT "Prik peil van de weg aan : "))
  (SETQ B (GETPOINT "Prik referentielijn aan  : "))
  (SETQ X (DISTANCE A B))
  (SETQ Y (/ (+ (/ X 5.) 5000.) 1000))
  (print \r)
  (print "Peil is :")
  (PRINT Y)
  (princ)
)
