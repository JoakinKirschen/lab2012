;;-----[ Deze functie altijd laten staan]------------------------------------
(defun TO_UMICORE ()
(princ "TO_UMICORE is loaded")
(princ)
)


;Make sure PS_Properties are set correctly!!!!!!!!!!!!!!!!!
;Import family template
;Import PS_Properties template
;Import Visual styles





(defun UMICORE_GroupList( / outLst)
  (vlax-for x(vla-get-Groups(vla-get-ActiveDocument(vlax-get-acad-object)))
  (setq outLst(cons(vla-get-Name x)outLst)))
)

(defun UMICORE_mfixLayer (layName c352 linetype plot / layName )
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


(defun C:TO_UMICORE ( / ss i e l a cur data oText NewTxt)	;<-- Color To Gray

;(command "-layer" "m" "10C" "c" "9" "10C" "lw" "0.09" "10C" "l" "continuous" "10C" "" "")
;(command "-layer" "m" "10D" "c" "9" "10D" "lw" "0.09" "10D" "l" "DASHDOT2" "" "" "")
;(command "-layer" "m" "10H2" "c" "9" "10H2" "lw" "0.09" "10H2" "l" "HIDDEN2" "10H2" "" "")
;(command "-layer" "m" "18C" "c" "4" "18C" "lw" "0.09" "18C" "l" "continuous" "18C" "" "")
;(command "-layer" "m" "18D" "c" "4" "18D" "lw" "0.09" "18D" "l" "DASHDOT2" "18D" "" "")
;(command "-layer" "m" "18H2" "c" "4" "18H2" "lw" "0.09" "18H2" "l" "HIDDEN2" "18H2" "" "")
;(command "-layer" "m" "18P" "c" "4" "18P" "lw" "0.09" "18P" "l" "HIDDEN2" "18P" "" "")
;(command "-layer" "m" "25C" "c" "2" "25C" "lw" "0.09" "25C" "l" "continuous" "25C" "" "")
;(command "-layer" "m" "25D" "c" "2" "25D" "lw" "0.09" "25D" "l" "DASHDOT2" "25D" "" "")
;(command "-layer" "m" "25H2" "c" "2" "10C" "lw" "0.09" "10C" "l" "HIDDEN2" "10C" "" "")
;(command "-layer" "m" "35C" "c" "1" "10C" "lw" "0.09" "10C" "l" "continuous" "10C" "" "")
;(command "-layer" "m" "35D" "c" "1" "10C" "lw" "0.09" "10C" "l" "DASHDOT2" "10C" "" "")
;(command "-layer" "m" "50C" "c" "7" "10C" "lw" "0.09" "10C" "l" "continuous" "10C" "" "")
;(command "-layer" "m" "50H2" "c" "7" "10C" "lw" "0.09" "10C" "l" "HIDDEN2" "10C" "" "")
;(command "-layer" "m" "70C" "c" "3" "10C" "lw" "0.09" "10C" "l" "continuous" "10C" "" "")
;(command "-layer" "m" "70H2" "c" "3" "10C" "lw" "0.09" "10C" "l" "HIDDEN2" "10C" "" "")
;(command "-layer" "m" "Dim25C" "c" "2" "10C" "lw" "0.09" "10C" "l" "continuous" "10C" "" "")
;(command "-layer" "m" "Hatch10C" "c" "9" "Hatch10C" "lw" "0.09" "Hatch10C" "l" "continuous" "Hatch10C" "" "")
;(command "-layer" "m" "Hatch18C" "c" "4" "10C" "lw" "0.09" "10C" "l" "continuous" "10C" "" "")
;(command "-layer" "m" "Hatch25C" "c" "2" "10C" "lw" "0.09" "10C" "l" "continuous" "10C" "" "")
(UMICORE_mfixLayer "ZW35V"    "4"     "continuous"   1 )
(UMICORE_mfixLayer "ZW25S"    "3"     "HIDDEN"   1 )
(UMICORE_mfixLayer "ZW1V"    "8"     "continuous"   1 )
(UMICORE_mfixLayer "ZW1S"    "8"     "HIDDEN2"   1 )

(UMICORE_mfixLayer "ZW35T"    "4"     "continuous"   1 )

(if (setq ss (ssget "_X" (list (cons 62 230)(cons 8 "3D_Visible"))))
      	(progn
		(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "ZW35V") l))
		)
		)
)

(if (setq ss (ssget "_X" (list (cons 62 231)(cons 8 "3D_Visible"))))
      	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "ZW1V") l))
		)
		)
)

(if (setq ss (ssget "_X" (list (cons 62 112)(cons 8 "3D_Hidden"))))
      	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "ZW25S") l))
		)
		)
)

(if (setq ss (ssget "_X" (list (cons 62 111)(cons 8 "3D_Hidden"))))
      	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "ZW1S") l))
		)
		)
)

(if (not PurgeAllNamedEmptyGroups)
	  (progn (load "L12_PURGEGROUP.LSP"))
)
(PurgeAllNamedEmptyGroups)

(if (setq ss (ssget "_X" (list (cons 0 "TEXT")(cons 8 "PS_Text"))))
		(progn
		(setq lst1 (UMICORE_GroupList))
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
	)))
	
(if (setq ss (ssget "_X" (list (cons 0 "TEXT")(cons 8 "PS_Text"))))
	(progn
      	(repeat (setq i (sslength ss))
	  	(setq e (entget (ssname ss (setq i (1- i))))
                  	      l (assoc -1 e))
                  	 (entmod (list'(62 . 256)(cons 8 "Text") l))
		)
		)
)



)
