
(DEFUN C:WEG (/ A X)

  (SETQ A (GETREAL "Geef hoogtepeil van de weg : "))
  (SETQ X (* 1 (- (* A 1000) 7000)))
  (COMMAND "OFFSET" X PAUSE PAUSE "")
  (PRINC)
)
