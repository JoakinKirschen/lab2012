

    ;* **************************************************************************
    ;* *************  BnS engineering bvba - Zelzate - CAD consult  *************
    ;* **************************************************************************
    ;* PROGRAMMA          : losse TEXT routine
    ;* MODULE             : TXT0.lsp
    ;* DOEL               : alle TEXT in tekening rotatiehoek 0 geven.
    ;* **************************************************************************


(defun c:TXT0 (/ selset	sslen txt_ent txt_data new_cons)

  (setq selset (ssget "X" (list (cons 0 "TEXT"))))
  (if (= selset nil)
    (progn
      (princ "\n *** FOUT: Geen TEXT gevonden (1)")
      (exit)
    )
  )
  (if (<= (sslength selset) 0)
    (progn
      (princ "\n *** FOUT: Geen TEXT gevonden (2)")
      (exit)
    )
  )
  (setq sslen (sslength selset))

  (while (> sslen 0)
    (princ (strcat "\n -- "
		   (itoa sslen)
		   " -----------------------------"
	   )
    )
    (setq txt_ent (ssname selset (1- sslen)))
    (if	(= txt_ent nil)
      (progn
	(princ "\n *** FOUT: Geen TEXT-entiteit gevonden (3)")
	(exit)
      )
    )
    (setq txt_data (entget txt_ent))
    (if	(= txt_data nil)
      (progn
	(princ "\n *** FOUT: Geen TEXT-spec gevonden (4)")
	(exit)
      )
    )
    (setq txt_rot (assoc 50 txt_data))
    (if	(/= txt_rot nil)
      (progn
	(setq new_cons (cons 50 0))
	(setq txt_data (subst new_cons (assoc 50 txt_data) txt_data))
	(entmod txt_data)
	(entupd txt_ent)
      )
    )
    (setq sslen (1- sslen))
  )
  (princ " done !")
  (princ)
)


