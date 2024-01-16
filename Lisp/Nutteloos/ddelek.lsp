
    ; FILE NAME : DDWERK.LSP
    ; CHRISTIAN SCHOUPPE
    ;--------------------------------------------------------------

(defun c:ddelek	(/ dcl_id)
  (SETQ	DCL_ID (LOAD_DIALOG "ELEK.DCL") ; LAAD DIALOOG

  )

    ; (IF (NOT (NEW_DIALOG "elek" DCL_ID))   ; EXIT IF NO DIALOG FOUND
    ;     (PROGN (RESTORE)			; RESTORE ENVIRONMENT
    ;      (exit))				; abort processing      
    ;)


  (NEW_DIALOG "elek" DCL_ID)

  (action_tile "Bestaand" "(setq base \"W-0000-Bestaand\")")
  (action_tile
    "Riool"
    "(setq base \"W-5200-Rioleringsinstal\")"
  )
  (action_tile "Water" "(setq base \"W-5300-Waterinstal\")")
  (action_tile "Koel" "(setq base \"W-5500-Koelinstal\")")
  (action_tile "Warm" "(setq base \"W-5600-Verwarming\")")
  (action_tile
    "Lucht"
    "(setq base \"W-5700-Luchtbeh-instal\")"
  )
  (action_tile "Regeling" "(setq base \"W-5800-Regeling\")")

  (hoofdvraag)
  (start_dialog) ; start dialog
  (unload_dialog dcl_id)

    ;(unload_dialog dcl_id)
  (groep base)
)   ;defun



(defun hoofdvraag ()

  (if (= "1" (get_tile "hoofdgr_knp"))
    (PROGN
      (setq llist '("eerste regel"	 "tweede regel"
		    "derde regel"	 "vierde regel"
		    "vijfde regel"
		   )
      )
      (start_list "subgroep_list")
      (mapcar 'add_list llist)
      (end_list)

    ) ;progn

    ;(print "hoofd")
  ) ;if


)   ;defun hoofdvraag

(defun groep (base /)
  (mlayer base)
  (C:runCommand)
)   ;defun groep