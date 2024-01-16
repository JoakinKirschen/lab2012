
    ;* Plaatsen van een Text symbool met de Y-coordinaat als waarde.
    ;*
    ;* Y-coordinaat van het aangeduide insertiepunt wordt gedeeld door
    ;* 1000 en de bekomen waarde wordt tot 3 cijfers na de komma
    ;* ingevuld in een textblock dat geplaatst wordt op dat insertiepunt. 
    ;* Indien de waarde > 0 wordt een "+" voor de waarde geplaatst.

(setq strBlockNaam "Nivo.dwg")

(defun CcAppend000 (strY / iLen	bFound i)

    ;* Zoeken naar een "." in de string:
  (setq	iLen   (strlen strY)
	bFound nil
  )
  (while (and (> iLen 0)
	      (= bfound nil)
	 )

    (if	(= (substr strY iLen 1) ".")
      (progn
	(setq bFound T)
      )
    )
    (setq iLen (1- iLen))
  )
    ;* "." gevonden ?
  (if (= bFound nil)
    (progn
    ;* geen "." in de string: ".000" toevoegen
      (princ "\n Getal is een INTEGER.\n")
      (setq strY (strcat strY ".000"))
    )
    (progn
      (princ "\n Getal is een REAL.\n")
    ;* Wel een "." in de string: een aantal "0" toevoegen tot 
    ;* max 3 cijfers na de komma
      (setq strY (strcat strY "000"))
      (setq iLen 1)
      (while (/= (substr strY ilen 1) ".")
	(setq iLen (1+ iLen))
      )

      (setq i 1)
      (while (<= i 3)
	(if (= (substr strY (+ iLen i)) "")
	  (setq strY (strcat strY "0"))
	)
	(setq i (1+ i))
      )
      (setq strY (substr strY 1 (+ iLen 3)))
    )
  )
  strY
)

(defun c:Nivo (/	iSavedAttReq iSavedAttDia pXY pY strBlock strY)
  (if (= schaal nil) (setq schaal 1))
  (if (= (setq strBlock (findfile strBlockNaam)) nil)
    (progn
      (princ
	(strcat "\n Kan block '" strBlockNaam "' niet vinden!")
      )
      (exit)
    )
  )

  (setq pXY (getpoint "Insertiepunt: "))
  (if (/= pXY nil)
    (progn
      (setq pY (/ (cadr pXY) 1000.0))
      (if (> pY 0)
	(progn
	  (setq strY (strcat "+" (rtos pY)))
	)
	(progn
	  (setq strY (rtos pY))
	)
      )
      (setq strY (CcAppend000 strY))

      (setq iSavedAttReq (getvar "ATTREQ"))
      (setvar "ATTREQ" 1)
      (setq iSavedAttDia (getvar "ATTDIA"))
      (setvar "ATTDIA" 0)

      (command "_Insert" strBlock pXY schaal schaal 0 strY)

      (setvar "ATTREQ" iSavedAttReq)
      (setvar "ATTDIA" iSavedAttDia)
    )
  )
  (princ)
)

(princ)