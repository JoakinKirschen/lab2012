
(DEFUN C:dp (/ A X)
  
  (SETQ A (GETREAL "Geef hoogtepeil van de weg : "))
  (SETQ X (* 5 (- (* A 1000) 5000)))
  (COMMAND "OFFSET" X PAUSE pause "")
  (COMMAND "INSERT" "PROFIEL" pause 1 1 0 "")
  (PRINC)
)
