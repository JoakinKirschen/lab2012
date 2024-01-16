;;-----[ Deze functie altijd laten staan]------------------------------------
(defun TO_GM ()
(princ "TO_GM is loaded")
(princ)
)

;Make sure PS_Properties are set correctly!!!!!!!!!!!!!!!!!
;Import family template
;Import PS_Properties template
;Import Visual styles





(defun AMG_GroupList( / outLst)
  (vlax-for x(vla-get-Groups(vla-get-ActiveDocument(vlax-get-acad-object)))
  (setq outLst(cons(vla-get-Name x)outLst)))
)


(defun GMC_mfixLayer (layName c352 linetype plot  / layName )
;(initerr)  
(setvar "cmdecho" 0)
(If (= (TBLSEARCH "LTYPE" linetype) nil)
		(command "-linetype" "l" linetype "acadiso.lin" "")
)
;(if (= (tblSearch "LAYER" layName) nil)
  (progn
  (entmake (list (cons 0 "LAYER")
                 (cons 100 "AcDbSymbolTableRecord")
                 (cons 100 "AcDbLayerTableRecord")
				 (cons 290 plot)
                 (cons 2 layName)
				 (cons 6 linetype)
                 (cons 70 0)
                 (cons 62 (atoi c352))
				 ;(cons 370 (fix (* 100 lw )))
            )
  )
  )
;)
(princ)
)


(defun C:TO_GM ( / ss i e l a cur data oText NewTxt)	;<-- Color To Gray


(GMC_mfixLayer "AC-2100-STAAL-PROF-co-35"    "2"     "continuous"   1  )
(GMC_mfixLayer "AC-2100-STAAL-PROF-hi2-12"    "3"     "HIDDEN2"   1  )
(GMC_mfixLayer "AC-0000-BESTAAND-co-06"    "1"     "continuous"   1  )
(GMC_mfixLayer "AC-0000-BESTAAND-hi2-06"    "1"     "HIDDEN2"   1  )
(GMC_mfixLayer "AC-0300-TEKST-35"   "2"     "continuous" 1  )

(if (setq ss (ssget "_X" (list (cons 62 230)(cons 8 "3D_Visible"))))
      	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "AC-2100-STAAL-PROF-co-35") l))
		)
		)
)

(if (setq ss (ssget "_X" (list (cons 62 231)(cons 8 "3D_Visible"))))
      	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "AC-0000-BESTAAND-co-06") l))
		)
		)
)

(if (setq ss (ssget "_X" (list (cons 62 112)(cons 8 "3D_Hidden"))))
      	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "AC-2100-STAAL-PROF-hi2-12") l))
		)
		)
)

(if (setq ss (ssget "_X" (list (cons 62 111)(cons 8 "3D_Hidden"))))
      	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "AC-0000-BESTAAND-hi2-06") l))
		)
		)
)

(if (not PurgeAllNamedEmptyGroups)
	  (progn (load "L12_PURGEGROUP.LSP"))
)
(PurgeAllNamedEmptyGroups)

(if (setq ss (ssget "_X" (list (cons 0 "TEXT")(cons 8 "PS_Text"))))
		(progn
		(setq lst1 (amg_GroupList))
		(princ lst1)
		(setq no 0)
		(repeat (length lst1)
		(command "-group" "r" (nth no lst1) (ssget "_X" (list (cons 8 "PS_Text"))) "")
		(setq no (1+ no))
		
		)
		;(sssetfirst nil (ssget "_X" '(8 . "PS_Text")))
      	;(command "_copy" (ssget  (list (cons 8 "PS_Text"))))
		;(command "d" "0, 0, 0")
		;(command  "s" "p")
		;(command ".erase")
		;
		;(setq ss2 (ssget "_X" (list (cons 0 "TEXT")(cons 8 "PS_Text"))))
		;(repeat (setq i (sslength ss2))
		;(setq e (entget (ssname ss2 (setq i (1- i))))
		;          	      l (assoc -1 e))
		;          	 (entmod (list'(62 . 256)(cons 8 "TEXT") l))
		;)
		;(command ".erase" ss "")
		;(repeat (setq i (sslength ss))
	  	;(setq e (entget (ssname ss (setq i (1- i))))
		;          	      l (assoc -1 e))
        ;          	 (entmod (list'(62 . 256)(cons 8 "Text") l))
		;)
		
			
(princ)     
)
)


(setq OldTxt " "
		  NewTxt "")
	
(if (setq ss (ssget "_X" (list (cons 0 "TEXT")(cons 8 "PS_Text"))))
	(progn
		
	(setq i (sslength ss))
	
	(while (not (minusp (setq i (1- i))))
		(setq oText (vlax-ename->vla-object (ssname ss i)))
		(setq Txt (vlax-get-property oText 'TextString))
		
		(if (vl-string-search OldTxt txt)
			(progn
				(setq newChg (vl-string-subst NewTxt OldTxt txt))
				(vlax-put-property oText 'TextString newchg)
				(vlax-invoke-method oText 'Update)
			)
		)
	))
)

(if (setq ss (ssget "_X" (list (cons 0 "TEXT")(cons 8 "PS_Text"))))
	(progn
		
	(setq i (sslength ss))
	
	(while (not (minusp (setq i (1- i))))
		(setq oText (vlax-ename->vla-object (ssname ss i)))
		(setq Txt (vlax-get-property oText 'TextString))
		
		(if (vl-string-search OldTxt txt)
			(progn
				(setq newChg (vl-string-subst NewTxt OldTxt txt))
				(vlax-put-property oText 'TextString newchg)
				(vlax-invoke-method oText 'Update)
			)
		)
	))
)
	
(if (setq ss (ssget "_X" (list (cons 0 "TEXT")(cons 8 "PS_Text"))))
	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "AC-0300-TEKST-35") l))
		)
)
)
)
