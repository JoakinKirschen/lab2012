
    ; FILE NAME : DDWERK.LSP
    ; CHRISTIAN SCHOUPPE
    ;--------------------------------------------------------------

(defun c:ddwerk	(/ dcl_id)
  (SETQ	DCL_ID (LOAD_DIALOG "WERK.DCL") ; LAAD DIALOOG

  )

    ; (IF (NOT (NEW_DIALOG "werk" DCL_ID))   ; EXIT IF NO DIALOG FOUND
    ;     (PROGN (RESTORE)			; RESTORE ENVIRONMENT
    ;      (exit))				; abort processing      
    ;)


  (NEW_DIALOG "werk" DCL_ID)

  (ACTION_TILE
    "Bestaand"
    "(setq BaseLayName \"W-0000-Bestaand\")(subgroep)"
  )
  (ACTION_TILE
    "Riool"
    "(setq BaseLayName \"W-5200-Rioleringsinstal\")"
  )
  (action_tile
    "Water"
    "(setq BaseLayName \"W-5300-Waterinstal\")"
  )
  (action_tile
    "Koel"
    "(setq BaseLayName \"W-5500-Koelinstal\")"
  )
  (action_tile
    "Warm"
    "(setq BaseLayName \"W-5600-Verwarming\")"
  )
  (action_tile
    "Lucht"
    "(setq BaseLayName \"W-5700-Luchtbeh-instal\")"
  )
  (action_tile
    "Regeling"
    "(setq BaseLayName \"W-5800-Regeling\")"
  )
  (updbox)
  (start_dialog) ; start dialog
  (unload_dialog dcl_id)
  (groep BaseLayname)

)   ;defun



(defun subgroep	()
  (cond	((= BaseLayName "W-0000-Bestaand") (print "bestaand"))
	((= BaseLayName "W-5200-Rioleringsinstal")
	 (setq llist '("W-5230-vuilwater" "W-5250-regenwater"))
	)
	((= BaseLayName "W-5300-Waterinstal")
	 (setq llist '("W-5310-koud-water"
		       "W-5330-warm-water"
		       "W-5400-gasinstallaties"
		       "W-5420-gebruikstoom"
		      )
	 )
	)
	((= BaseLayName "W-5500-Koelinstal")
	 (setq llist '("W-5511-gkw-toevoer"
		       "W-5512-gkw-retour"
		       "W-5513-condens"
		      )
	 )
	)
	((= BaseLayName "W-5700-Luchtbeh-instal")
	 (setq llist '("W-5630-cv"
		       "W-5631-cv-toevoer"
		       "W-5632-cv-retour"
		       "W-5680-lokaal"
		      )
	 )
	)
	((= BaseLayName "W-5800-Regeling")
	 (setq llist '("W-5701-lb-pulsie" "5702-lb-extractie"))
	)
	(nil (princ))
	((not nil) (princ))
  ) ;cond

  (if (= "1" (get_tile "hoofdgr_knp"))
    (PROGN
      (print "kijk hier")
      (updbox)
    ) ;progn
  ) ;if
)   ;defun hoofdvraag

(defun groep (gbase /)
  (mlayer gbase)
  (C:runCommand)
)   ;defun groep

(defun updbox ()
  (start_list "subgroep_list")
  (mapcar 'add_list llist)
  (end_list)
)   ;defun