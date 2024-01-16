
(DEFUN C:WEG (/ A X)

  (SETQ A (GETREAL "Geef hoogtepeil van de weg : "))
  (SETQ X (* 5 (- (* A 1000) 5000)))
  (COMMAND "OFFSET" X PAUSE PAUSE "")
  (PRINC)
)
