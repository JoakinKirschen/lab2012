;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_AMGREADEXCEL ()
(princ "L12_AMGREADEXCEL is loaded")
(princ)
)

(defun L12_AMG_CheckTitleblock ( / cntr Planomschrijving1 excellist dwgname lvl1 matchpos matchposlist freespot targetline
 ss block blocklist DPlannr DFolio DPlanomschrijving1 DPlanomschrijving2 DPlanomschrijving3 DPlanomschrijving4 DFolioomschrijving1 DFolioomschrijving2 DIndice
 DBeschrijvingIndice DFormaat DSchaal DFase DFilenaam DDiscipline DType DFiletype)

(if (not(SSGET "X" (LIST '(0 . "INSERT") '(2 . "titelhoek_arcelormittal"))))
(progn (alert "No corresponding titleblock found!") (exit))
)

(setq ss (SSGET "X" (LIST '(0 . "INSERT") '(2 . "titelhoek_arcelormittal"))))
(if (= (sslength ss) 1)
	(setq block (vlax-ename->vla-object (ssname ss 0 )))
	(if (> (sslength ss) 1)
	(setq block (L12_AMG_tester))
	(princ "\nNo block AMG titleblock found")
	)
)
(setq blocklist ( LM:vl-getattributes block))
(setq 
DPlannr (cdr(assoc "PLANNUMMER" blocklist))
DFolio (cdr(assoc "FOLIO" blocklist))
DPlanomschrijving1 (cdr(assoc "TITEL1" blocklist))
DPlanomschrijving2 (cdr(assoc "TITEL2" blocklist))
DPlanomschrijving3 (cdr(assoc "TITEL3" blocklist))
DPlanomschrijving4 (cdr(assoc "TITEL4" blocklist))
DFolioomschrijving1 (cdr(assoc "TITEL5" blocklist))
DFolioomschrijving2 (cdr(assoc "TITEL6" blocklist))
DIndice (cdr(assoc "INDX" blocklist))
DBeschrijvingIndice (cdr(assoc "BESCHRIJVINGX" blocklist))
DFormaat (cdr(assoc "GEN-TITLE-SIZ" blocklist))
DSchaal (cdr(assoc "GEN-TITLE-SCA" blocklist))
DFase (cdr(assoc "FASE" blocklist))
DFilenaam dwgname
DDiscipline (cdr(assoc "VAKGEBIED" blocklist))
DType (cdr(assoc "TYPE_PLAN" blocklist))
DFiletype (cdr(assoc "FILETYPE" blocklist))
)


(if (member Dfolio '("0000" "0001"))(setq DFolio "")(setq DFolio "\nFolio moet 0000 of 0001 zijn.\n"))
(if (= DPlannr "")(setq DPlannr "\nPlannummer is niet ingevuld.\n")(setq DPlannr ""))
(if (= DFolioomschrijving1 "")(setq DFolioomschrijving1 "\nTITEL5 is niet ingevuld.\n") (setq DFolioomschrijving1 "") )
(if (= DFolioomschrijving2 "")(setq DFolioomschrijving2 "\nTITEL6 is niet ingevuld.\n") (setq DFolioomschrijving2 "") )
(if (member DIndice '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))(setq DIndice "") (setq DIndice "\nINDX moet een hoofdletter zijn.\n"))
(if (= DBeschrijvingIndice "")(setq DBeschrijvingIndice "\nBESCHRIJVINGX is niet ingevuld.\n") (setq DBeschrijvingIndice "") )
(if (member DFormaat '("A0" "A1" "A2" "A3" "A4")) (setq DFormaat "") (setq DFormaat "\nGEN-TITLE-SIZ moet A0 A1 A2 A3 A4 zijn.\n"))
(if (member DSchaal '("1:1" "1:2" "1:5" "1:10" "1:20" "1:25" "1:50" "1:100" "1:200" "1:500" "1:1000")) (setq DSchaal "") (setq DSchaal "\nGEN-TITLE-SCA moet volgende vorm hebben 1:50.\n"))
(if (member DFase '("TER GOEDKEURING" "GOEDGEKEURD" "DEFINITIEF" "ONGELDIG")) (setq DFase "") (setq DFase "\nFASE moet een van de volgende statussen zijn: \nTer Goedkeuring - Goedgekeurd - Definitief - Ongeldig\n"))
(if (member DDiscipline '("0 PLAN" "1 INFR" "3 MECH" "4 FLUI" "5 ELEK" "6 BOUW" "7 PROCES" "8 HYDR" "9 PNEU"  )) (setq DDiscipline "") 
(setq DDiscipline "\nVAKGEBIED moet een van de volgende statussen zijn:
 0 PLAN - 1 INFRA - 3 MECH - 4 FLUI - 5 ELEK 
 6 BOUW - 7 PROCES - 8 HYDR - 9 PNEU"))

(alert
(strcat
DFolio DPlannr DFolioomschrijving1 DFolioomschrijving2 DIndice DBeschrijvingIndice DFormaat DSchaal DFase DDiscipline
)
)

(princ "\nMade by Joakin Kirschen")
(princ)
)



(defun L12_AMG_Titleblock (state / state destfile cntr excellist dwgname lvl1 matchpos matchposlist freespot targetline
 ss block blocklist XPlannr XFolio XPlanomschrijving1 XPlanomschrijving2 XPlanomschrijving3 XPlanomschrijving4 XFolioomschrijving1
 XFolioomschrijving2 XIndice XBeschrijvingIndice XFormaat XSchaal XFase XFilenaam XAfdeling XDiscipline XType XFiletype XClassificatie
 DPlannr DFolio DPlanomschrijving1 DPlanomschrijving2 DPlanomschrijving3 DPlanomschrijving4 DFolioomschrijving1 DFolioomschrijving2 DIndice
 DBeschrijvingIndice DFormaat DSchaal DFase DFilenaam DDiscipline DType DFiletype DPDiscipline)
(if (= (substr (getvar "dwgname") 1 7) "Drawing") 
(progn (alert "Please save the file first with correct file name and in the correct folder. \nPlanname cannot start with -Drawing-") (exit))
)
(if (not(SSGET "X" (LIST '(0 . "INSERT") '(2 . "titelhoek_arcelormittal"))))
(progn (alert "No corresponding titleblock found!") (exit))
) 


(setq destfile (strcat (getvar "dwgprefix") "Planlijst Smarteam batch upload.xlsm"))
(if (not(findfile destfile))
	(progn 
		(vl-file-copy (strcat LabPathDest "\\Planlijst Smarteam batch upload.xlsm") destfile)	
	)
)

(setq excellist (GetExcel destfile "Planlijst" "S100"))
(setq dwgname (getvar "dwgname"))

;; find filename match
(setq lvl1 (length excellist))
(setq cntr 1)                        
(setq matchpos 0)
(setq matchposlist 0)
(setq freespot 0)
(setq targetline 0)

(while (< cntr lvl1)
	(if (or(= (nth 13 (nth cntr excellist)) dwgname)(= (nth 13 (nth cntr excellist)) ""))
		(progn
		(if (= (nth 13 (nth cntr excellist)) "")(setq freespot cntr))
		(if (= (nth 13 (nth cntr excellist)) dwgname)(progn(setq matchpos cntr)(princ "\nWe have a match.")))
;		(setq matchposlist (nth matchpos excellist))
		(setq cntr lvl1)
		)
	)
	(setq cntr(+ cntr 1))           
)

(if (and(= matchpos 0)(not(= freespot 0)))(progn(setq targetline freespot)(setq matchposlist (nth targetline excellist))))
(if (not(= matchpos 0))(progn(setq targetline matchpos)(setq matchposlist (nth targetline excellist))))


(if (not(= targetline 0))
	(progn
	(setq ss (SSGET "X" (LIST '(0 . "INSERT") '(2 . "titelhoek_arcelormittal"))))
	(if (= (sslength ss) 1)
	(setq block (vlax-ename->vla-object (ssname ss 0 )))
	(if (> (sslength ss) 1)
	(setq block (L12_AMG_tester))
	(princ "\nNo block AMG titleblock found")
	)
	)
	(setq blocklist ( LM:vl-getattributes block))
	(setq 
	XPlannr (nth 0 matchposlist)
	XFolio (nth 1 matchposlist)
	XPlanomschrijving1 (nth 2 matchposlist)
	XPlanomschrijving2 (nth 3 matchposlist)
	XPlanomschrijving3 (nth 4 matchposlist)
	XPlanomschrijving4 (nth 5 matchposlist)
	XFolioomschrijving1 (nth 6 matchposlist)
	XFolioomschrijving2 (nth 7 matchposlist)
	XIndice (nth 8 matchposlist)
	XBeschrijvingIndice (nth 9 matchposlist)
	XFormaat (nth 10 matchposlist)
	XSchaal (nth 11 matchposlist)
	XFase (nth 12 matchposlist)
	XFilenaam (nth 13 matchposlist)
	XAfdeling (nth 14 matchposlist)
	XDiscipline (nth 15 matchposlist)
	XType (nth 16 matchposlist)
	XFiletype (nth 17 matchposlist)
	XClassificatie (nth 18 matchposlist)
	)
	(setq 
	DPlannr (cdr(assoc "PLANNUMMER" blocklist))
	DFolio (cdr(assoc "FOLIO" blocklist))
	DPlanomschrijving1 (cdr(assoc "TITEL1" blocklist))
	DPlanomschrijving2 (cdr(assoc "TITEL2" blocklist))
	DPlanomschrijving3 (cdr(assoc "TITEL3" blocklist))
	DPlanomschrijving4 (cdr(assoc "TITEL4" blocklist))
	DFolioomschrijving1 (cdr(assoc "TITEL5" blocklist))
	DFolioomschrijving2 (cdr(assoc "TITEL6" blocklist))
	DIndice (cdr(assoc "INDX" blocklist))
	DBeschrijvingIndice (cdr(assoc "BESCHRIJVINGX" blocklist))
	DFormaat (cdr(assoc "GEN-TITLE-SIZ" blocklist))
	DSchaal (cdr(assoc "GEN-TITLE-SCA" blocklist))
	DFase (cdr(assoc "FASE" blocklist))
	DFilenaam dwgname
	DDiscipline (cdr(assoc "VAKGEBIED" blocklist))
	DType (cdr(assoc "TYPE_PLAN" blocklist))
	DFiletype (cdr(assoc "FILETYPE" blocklist))
	)
	)
)

	(cond 
		((= XDiscipline "0 Planningen")(setq XPDiscipline "0 PLAN"))
		((= XDiscipline "1 Infrastructuur")(setq XPDiscipline "1 INFRA"))
		((= XDiscipline "3 Mechanica")(setq XPDiscipline "3 MECH"))
		((= XDiscipline "4 Fluïda")(setq XPDiscipline "4 FLUI"))
		((= XDiscipline "5 Elektriciteit")(setq XPDiscipline "5 ELEK"))
		((= XDiscipline "6 Bouwkunde")(setq XPDiscipline "6 BOUW"))
		((= XDiscipline "7 Proces instrumentatie")(setq XPDiscipline "7 PROCES"))
		((= XDiscipline "8 Hydraulica")(setq XPDiscipline "8 HYDR"))
		((= XDiscipline "9 Pneumatica")(setq XPDiscipline "9 PNEU"))
		(t (setq XDiscipline "Invallid"))
	)
	(cond 
		((= DDiscipline "0 PLAN")(setq DPDiscipline "0 Planningen"))
		((= DDiscipline "1 INFRA")(setq DPDiscipline "1 Infrastructuur"))
		((= DDiscipline "3 MECH")(setq DPDiscipline "3 Mechanica"))
		((= DDiscipline "4 FLUI")(setq DPDiscipline "4 Fluïda"))
		((= DDiscipline "5 ELEK")(setq DPDiscipline "5 Elektriciteit"))
		((= DDiscipline "6 BOUW")(setq DPDiscipline "6 Bouwkunde"))
		((= DDiscipline "7 PROCES")(setq DPDiscipline "7 Proces instrumentatie"))
		((= DDiscipline "8 HYDR")(setq DPDiscipline "8 Hydraulica"))
		((= DDiscipline "9 PNEU")(setq DPDiscipline "9 Pneumatica"))
		(t (setq DDiscipline "Invallid"))
	)
;(0(GEN-TITLE-SCA . x:x) 1(GEN-TITLE-SIZ . ) 2(STUDIE . GRONTMIJ) 3(NAAM_GETEKEND . )
; 4(NAAM_NAGEZIEN . ) 5(DATUM_GETEKEND . xx/xx/xxxx) 
;6(DATUM_NAGEZIEN . ) 7(TWANRX . ) 8(NAAMX . ) 9(NAGEZIENX . ) 10(SAMENSTELLING1 . ) 
;11(SAMENSTELLING2 . ) 12(SAMENSTELLING3 . ) 13(SAMENSTELLING4 . ) 14(PLANNUMMER . ) 
;15(FOLIO . ) 16(INDX . A) 17(DATUMX . ) 18(BESCHRIJVINGX . ) 19(TITEL1 . ) 20(TITEL2 . ) 
;21(TITEL3 . ) 22(TITEL4 . ) 23(TITEL5 . ) 24(TITEL6 . ) 25(FASE . ) 26(VAKGEBIED . 6 BOUW) 
;27(FILETYPE . ) 28(MEERVOUDIG_GEBRUIKT . ) 29(TYPE_PLAN . ))

;car
;cdr
(if (= state 1) ;Van excel naar dwgblock
(progn
	(if (not(= matchpos 0))
		(progn
		(setq 
		DPlannr XPlannr
		DFolio XFolio
		DPlanomschrijving1 XPlanomschrijving1
		DPlanomschrijving2 XPlanomschrijving2
		DPlanomschrijving3 XPlanomschrijving3
		DPlanomschrijving4 XPlanomschrijving4
		DFolioomschrijving1 XFolioomschrijving1
		DFolioomschrijving2 XFolioomschrijving2
		DIndice XIndice
		DBeschrijvingIndice XBeschrijvingIndice
		DFormaat XFormaat
		DSchaal XSchaal
		DFase XFase
		DDiscipline XPDiscipline
		DType XType
		DFiletype XFiletype
		)
		(setq writelist	(list
;			(cons "GEN-TITLE-SCA" DSchaal)(cons "GEN-TITLE-SIZ" DFormaat)(cons "STUDIE"  "GRONTMIJ")
	;		(cons "NAAM_GETEKEND" "")(cons "NAAM_NAGEZIEN" "")(cons "DATUM_GETEKEND" "")
	;		(cons "DATUM_NAGEZIEN" "")(cons "TWANRX" "")(cons "NAAMX" "")(cons "NAGEZIENX" "")(cons "SAMENSTELLING1" "")
	;		(cons "SAMENSTELLING2" "")(cons "SAMENSTELLING3" "")(cons "SAMENSTELLING4" "")
			(cons "PLANNUMMER" DPlannr)
			(cons "FOLIO" DFolio)
			;(cons "INDX" DIndice)(cons "DATUMX" "")(cons "BESCHRIJVINGX" DBeschrijvingIndice)
			(cons "TITEL1" DPlanomschrijving1)(cons "TITEL2" DPlanomschrijving2)(cons "TITEL3" DPlanomschrijving3)
			(cons "TITEL4" DPlanomschrijving4)
	;		(cons "TITEL5" DFolioomschrijving1)(cons "TITEL6" DFolioomschrijving2)
	;		(cons "FASE" "")
	;		(cons "VAKGEBIED" "6 BOUW")
	;		(cons "FILETYPE" DFiletype)
	;		(cons "MEERVOUDIG_GEBRUIKT" "")
	;		(cons "TYPE_PLAN" DType)
			)
		)
		(LM:vl-setattributevalues block writelist)
	)
	
	(alert "Tekening nog niet aanwezig in de plannenlijst. \nCheck de naam van de dwg in de lijst (kolom N).")
	)
))
(if (= state 2) ;Van excel naar dwgblockalles
(progn
	(if (not(= matchpos 0))
		(progn
		(setq 
		DPlannr XPlannr
		DFolio XFolio
		DPlanomschrijving1 XPlanomschrijving1
		DPlanomschrijving2 XPlanomschrijving2
		DPlanomschrijving3 XPlanomschrijving3
		DPlanomschrijving4 XPlanomschrijving4
		DFolioomschrijving1 XFolioomschrijving1
		DFolioomschrijving2 XFolioomschrijving2
		DIndice XIndice
		DBeschrijvingIndice XBeschrijvingIndice
		DFormaat XFormaat
		DSchaal XSchaal
		DFase XFase
		DDiscipline XPDiscipline
		DType XType
		DFiletype XFiletype
		)
		(setq writelist	(list
			(cons "GEN-TITLE-SCA" DSchaal)(cons "GEN-TITLE-SIZ" DFormaat)(cons "STUDIE"  "GRONTMIJ")
	;		(cons "NAAM_GETEKEND" "")(cons "NAAM_NAGEZIEN" "")(cons "DATUM_GETEKEND" "")
	;		(cons "DATUM_NAGEZIEN" "")(cons "TWANRX" "")(cons "NAAMX" "")(cons "NAGEZIENX" "")(cons "SAMENSTELLING1" "")
	;		(cons "SAMENSTELLING2" "")(cons "SAMENSTELLING3" "")(cons "SAMENSTELLING4" "")
			(cons "PLANNUMMER" DPlannr)
			(cons "FOLIO" DFolio)
			(cons "INDX" DIndice)(cons "BESCHRIJVINGX" DBeschrijvingIndice)
			(cons "TITEL1" DPlanomschrijving1)(cons "TITEL2" DPlanomschrijving2)(cons "TITEL3" DPlanomschrijving3)
			(cons "TITEL4" DPlanomschrijving4)
			(cons "TITEL5" DFolioomschrijving1)(cons "TITEL6" DFolioomschrijving2)
			(cons "FASE" DFase)
			(cons "VAKGEBIED" DDiscipline)
			(cons "FILETYPE" DFiletype)
	;		(cons "MEERVOUDIG_GEBRUIKT" "")
			(cons "TYPE_PLAN" DType)
			)
		)
		(LM:vl-setattributevalues block writelist)
	)
	
	(alert "\nTekening nog niet aanwezig in de plannenlijst. \nNo data to import.")
	)
))

(if (= state 3)
(progn
	(if (not(= targetline 0))
		(progn
		(setq 
		XPlannr DPlannr
		XFolio DFolio
		XPlanomschrijving1 DPlanomschrijving1
		XPlanomschrijving2 DPlanomschrijving2
		XPlanomschrijving3 DPlanomschrijving3
		XPlanomschrijving4 DPlanomschrijving4
		XFolioomschrijving1 DFolioomschrijving1
		XFolioomschrijving2 DFolioomschrijving2
		XIndice DIndice
		XBeschrijvingIndice DBeschrijvingIndice
		XFormaat DFormaat
		XSchaal DSchaal
		XFase DFase
		XDiscipline DPDiscipline
		XType DType
		XFiletype DFiletype
		XFilenaam dwgname
		)
		(OpenExcel destfile "Planlijst" nil)
		(PutCell (strcat "A" (itoa (+ 1 targetline)))
		( list
		XPlannr
		XFolio
		))
		(PutCell (strcat "G" (itoa (+ 1 targetline)))( list
		XFolioomschrijving1
		XFolioomschrijving2
		XIndice
		XBeschrijvingIndice
		XFormaat
		XSchaal
		XFase
		XFilenaam
		))
		(PutCell (strcat "P" (itoa (+ 1 targetline)))
		( list
		XDiscipline
		))
		(PutCell (strcat "R" (itoa (+ 1 targetline)))
		( list
		XFiletype
		))
		(CloseExcel destfile)
		)
)
)
)
(princ "\nMade by Joakin Kirschen")
(princ)
)
;; Set Attribute Values  -  Lee Mac
;; Sets attributes with tags found in the association list to their associated values.
;; blk - [vla] VLA Block Reference Object
;; lst - [lst] Association list of ((<tag> . <value>) ... )
;; Returns: nil

(defun LM:vl-setattributevalues ( blk lst / itm )
    (foreach att (vlax-invoke blk 'getattributes)
        (if (setq itm (assoc (vla-get-tagstring att) lst))
            (vla-put-textstring att (cdr itm))
        )
    )
)

(defun LM:setattributevalues ( blk lst / enx itm )
    (while (= "ATTRIB" (cdr (assoc 0 (setq enx (entget (setq blk (entnext blk)))))))
        (if
            (and
                (setq itm (assoc (cdr (assoc 2 enx)) lst))
                (entmod (subst (cons 1 (cdr itm)) (assoc 1 enx) enx))
            )
            (entupd blk)
        )
    )
)

;; Get Attributes  -  Lee Mac
;; Returns an association list of attributes present in the supplied block.
;; blk - [vla] VLA Block Reference Object
;; Returns: [lst] Association list of ((<Tag> . <Value>) ... )

(defun LM:vl-getattributes ( blk )
    (mapcar '(lambda ( att ) (cons (vla-get-tagstring att) (vla-get-textstring att)))
        (vlax-invoke blk 'getattributes)
    )
)

(defun L12_AMG_tester ( / obj )
(setq obj (car (entsel "\nSelect block: ")))
(setq obj (vlax-ename->vla-object obj))
obj
)



