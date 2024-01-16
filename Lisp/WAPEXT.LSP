 ; ****************  cadsym  ************** BGLWAP
 ;------------------------------------------------

(princ
  "De lisproutine 'BGLWAP' van CADsym wordt geladen ......"
)

(defun reget (prmpt defolt / retour)
  (princ (strcat prmpt "<"))
  (princ defolt)
  (princ "> : ")
  (if (= (setq retour (getreal)) nil)
    defolt
    retour
  )
)

(defun afget (prmpt defolt / retour)
  (princ (strcat prmpt "<"))
  (princ defolt)
  (princ "> : ")
  (if (= (setq retour (getdist)) nil)
    defolt
    retour
  )
)

(defun inget (prmpt defolt / retour)
  (princ (strcat prmpt "<"))
  (princ defolt)
  (princ "> : ")
  (if (= (setq retour (getint)) nil)
    defolt
    retour
  )
)

(defun laagsave () (setq laag (getvar "clayer")))

(defun laagrest	()
  (if laag
    (command "layer" "s" laag "")
  )
)

(DEFUN SETLAG (SETLAGLG)
  (SETVAR "CMDECHO" 0)
  (SETQ SETLAGGEG (TBLSEARCH "LAYER" SETLAGLG))
  (IF SETLAGGEG
    (PROGN
      (IF (< (CDR (ASSOC 62 SETLAGGEG)) 0)
	(PROGN
	  (PRINC
	    (STRCAT "\nDe laag " setlaglg " wordt eerst AAN gezet.\n")
	  )
	  (COMMAND "LAYER" "ON" SETLAGLG "")
	)
      )
      (IF (= (REM (CDR (ASSOC 70 SETLAGGEG)) 2) 1)
	(PROGN
	  (PRINC
	    (STRCAT "\nDe laag " setlaglg " wordt eerst ONTDOOIT.\n")
	  )
	  (COMMAND "LAYER" "THAW" SETLAGLG "")
	)
      )
    )
    (PROGN
      (PRINC
	(STRCAT "\nDe laag " setlaglg " wordt eerst aangemaakt.\n")
      )
      (COMMAND "LAYER" "M" SETLAGLG "")
    )
  )
  (COMMAND "LAYER" "S" SETLAGLG "")
) ; einde setlag

;*************************************************************************************************************************************
;Functie die maatlijn met text tekent
(DEFUN C:BGLL (/ AANTAL PNT PNT1 LAAG TEKSCH)
  (SETVAR "CMDECHO" 0)
  (SETQ	LAAG   (GETVAR "CLAYER")
	TEKSCH (GETVAR "DIMSCALE")
	HPI    (/ PI 2)
	AHPI   (* PI 1.5)
  )
  (SETVAR "OSMODE" 512)
  (GRAPHSCR)
  (INITGET "C")
  (SETQ	PNT
	 (GETPOINT
	   "\n[C]ont.lastpoint/RETURN=cont./<Geef ref.punt> : NEARest to "
	 )
  )
  (SETVAR "OSMODE" 0)
  (IF (AND (/= PNT "C") (/= PNT NIL))
    (PROGN
      (INITGET 1)
      (SETQ HOE	 (GETANGLE PNT " Geef richting ")
	    PNT	 (POLAR	PNT
			(IF (AND (>= HOE 0.0) (< HOE PI))
			  HPI
			  AHPI
			)
			(* TEKSCH 7)
		 )
	    YPNT (CADR PNT)
      )
    )
    (IF	(= YPNT NIL)
      (PROGN
	(PRINC "Kan niet continueren .........  ")
	(/ YPNT 2)
      )
    )
  )
  (IF (= PNT "C")
    (SETQ PNT1 PNT2)
    (PROGN (SETVAR "OSMODE" 32)
	   (INITGET 1 "R")
	   (SETQ
	     PNT1 (GETPOINT "\n[R]ef.punt<Geef beginpunt> : INTERsec of ")
	   )
	   (IF (= PNT1 "R")
	     (SETQ PNT1 (REF))
	   )
	   (SETVAR "OSMODE" 0)
	   (SETQ PNT1 (LIST (CAR PNT1) YPNT))
    )
  )
  (SETVAR "OSMODE" 32)
  (INITGET 1 "R")
  (SETQ PNT2 (GETPOINT PNT1 "[R]ef.punt<eindpunt> : INTERsec of "))
  (IF (= PNT2 "R")
    (SETQ PNT2 (REF))
  )
  (SETQ	PNT2 (LIST (CAR PNT2) YPNT)
	AFST (DISTANCE PNT1 PNT2)
	HOE  (ANGLE PNT1 PNT2)
  )
  (SETVAR "OSMODE" 0)
  (INITGET 4)
  (SETQ AANTAL (GETINT "\nAantal/<berekening a.d.h. afstand> : "))
  (PRINC "\nNegatief voor n-meth. / pos. voor n+1-methode.")

  (IF AANTAL
    (SETQ HOH  (REGET "  h.o.h. = " HOH)
	  AFST (* (- AANTAL
		     (IF (< HOH 0)
		       0
		       1
		     )
		  )
		  (ABS HOH)
	       )
	  PNT2 (POLAR PNT1 HOE AFST)
    )
    (PROGN
      (SETQ HOH	   (REGET "  h.o.h. = " HOH)
	    AANTAL (+ (FIX (/ (+ AFST (/ HOH 2.0)) (ABS HOH))) 1)
      )
      (PRINC "Afstand = ")
      (PRINC AFST)
      (SETQ AANTAL (INGET "  Aantal " AANTAL))
    )
  )
  (INITGET (+ 2 4))
  (SETQ BDIAM (INGET "diameter " BDIAM))
  ;(COMMAND "LAYER" "s" "WAPTXT" "")			;beter current layer gebruiken
  ;(COMMAND "STYLE" "" "" "0" "" "" "" "" "")		;beter current layer gebruiken
  (COMMAND "PLINE"
	   (POLAR PNT1 (+ HOE HPI) (* TEKSCH 3))
	   "W"
	   "0"
	   "0"
	   (POLAR PNT1 (- HOE HPI) (* TEKSCH 3))
	   PNT1
	   "W"
	   "0"
	   (* TEKSCH 1.5)
	   (POLAR PNT1 HOE (* TEKSCH 5))
	   "W"
	   "0"
	   "0"
	   (POLAR PNT2 (+ HOE PI) (* TEKSCH 5))
	   "W"
	   (* TEKSCH 1.5)
	   "0"
	   PNT2
	   "W"
	   "0"
	   "0"
	   (POLAR PNT2 (+ HOE HPI) (* TEKSCH 3))
	   (POLAR PNT2 (- HOE HPI) (* TEKSCH 3))
	   ""
  )
  (COMMAND "TEXT"
	   "C"
	   (POLAR (POLAR PNT1 (ANGLE PNT1 PNT2) (/ AFST 2))
		  HPI
		  (* TEKSCH 0.9)
	   )
	   (* TEKSCH 2.5)
	   "0"
	   (STRCAT (ITOA AANTAL)
		   BGLSHRSP
		   "%%c"
		   (ITOA BDIAM)
		   "-"
		   (RTOS (ABS HOH))
	   )
  )
  (setq	naam (entlast)
	geg  (entget naam)
	pnt3 (cdr (assoc 10 geg))
	pnt4 (cdr (assoc 11 geg))
  )
  (if (> (* 2.0 (distance pnt3 pnt4))
	 (- afst (* 6.0 (getvar "DIMSCALE")))
      )
    (command ".MOVE"
	     naam
	     ""
	     pnt4
	     (strcat "@0," (rtos (getvar "DIMSCALE") 2 2))
    )
  )

  (COMMAND "LAYER" "S" LAAG "")
) ; einde beugellijn funktie

(SETQ HOH      300.0
      BDIAM    8
      BGLSHRSP " BGLS "
)
 ;  einde instellen default waarden

(DEFUN C:BH ()
  (IF (= BGLSHRSP " BGLS ")
    (SETQ BGLSHRSP " HRSP ")
    (SETQ BGLSHRSP " BGLS ")
  )
)
; bgls routine met style 0 op het eind


;**************************************************************************************************************
;funktie die beugels tekent
(DEFUN C:BGLS ()
  (setq schaal (L12_getschaal))
  (SETVAR "CMDECHO" 0)

  (setq snapie (GETVAR "OSMODE"))

  (setq	LO (GETPOINT "\nGeef linksonder hoekpunt dsn  :")
	RB (GETCORNER LO "\nGeef rechtsboven hoekpunt dsn :")
  )
 
  (initget (+ 1 2 4))
  (setq BS (getint "\nGeef de schaal van de doorsnede: "))
  (setq	SF  (/ schaal BS))

  (initget (+ 1 2 4))
  (setq dekking (getint "\nGeef de betondekking in mm: "))
  
  (initget (+ 1 4))
  (setq	HL (getint "\nGeef haaklengte beugel: "))
  
  (initget (+ 1 4))
  (setq	AB (getint "\nGeef het aantal staven bovenwapening: "))
  (if (> AB 0)
    (progn
    (initget (+ 1 2 4))
    (setq BDI (getint "\nGeef de diameter van bovenwap: "))
    (setq BD (* SF (fix (sqrt (* BDI 10))) 2 ))
	)
    (progn
    (setq BDI 1)
    (setq BD 1))
  )
    
  (initget (+ 1 4))
  (setq	AO (getint "\nGeef het aantal staven onder:  "))
  (if (> AO 0)
    (progn
    (initget (+ 1 2 4))
    (setq ODI (getint "\nGeef de diameter van de onderwapening: "))
    (setq OD (* SF (fix (sqrt (* ODI 10))) 2 ))
	)
    (progn
    (setq ODI 1)
    (setq OD 1))
  )
  
  (initget (+ 1 4))
  (setq	AF (getint "\nAantal flankstaven (per zijde): "))
  (if (> AF 0)
    (progn
    (initget (+ 1 2 4))
    (setq FDI (getint "\nGeef de diameter van de zijwapening: " ))
    (setq FD (* SF (fix (sqrt (* FDI 10))) 2 ))
	)
    (progn
    (setq FDI 1)
    (setq FD 1))
  )
  
  (SETQ	X1 (CAR LO)
	Y1 (CADR LO)
	X2 (CAR RB)
	Y2 (CADR RB)
  )
  (IF (< X2 X1)
    (SETQ X3 X1
	  X1 X2
	  X2 X3
    )
  )
  (IF (< Y2 Y1)
    (SETQ Y3 Y1
	  Y1 Y2
	  Y2 Y3
    )
  )
  (SETQ	;SCH (/ (GETVAR "DIMSCALE") 2)
	;SF  (/ (* SCH 2) (FLOAT BS))
    
	SCH (* SF 5)				;reele haaklengte
	OPT (* dekking SF)				;reele dekking
	KROM (+(/(min BD OD)2)(* SF 4))
	RB11 (POLAR (LIST (- X2 OPT) (+ (- Y2 OPT) SCH)) PI (* HL SF))	;rechts boven 1
	RB12 (LIST (- X2 OPT KROM) (+ (- Y2 OPT) SCH))
	RB13 (LIST (- X2 OPT) (+ (- Y2 OPT KROM) SCH))
	RO1  (LIST (- X2 OPT) (+ Y1 OPT KROM))
	RO2  (LIST (- X2 OPT KROM) (+ Y1 OPT))
	LO1  (LIST (+ X1 OPT KROM) (+ Y1 OPT))		;links onder
	LO2  (LIST (+ X1 OPT) (+ Y1 OPT KROM))		;links onder
	LB1  (LIST (+ X1 OPT) (- Y2 OPT KROM))		;links boven
	LB2  (LIST (+ X1 OPT KROM) (- Y2 OPT ))		;links boven
	RB23 (POLAR (LIST (+ (- X2 OPT) SCH) (- Y2 OPT)) (* PI 1.5) (* HL SF))
	RB21 (LIST (+ (- X2 OPT KROM) SCH) (- Y2 OPT))
	RB22 (LIST (+ (- X2 OPT) SCH) (- Y2 OPT KROM))	;rechts boven 2
	RB1  (LIST (- X2 OPT KROM) (- Y2 OPT))
	RB2  (LIST (- X2 OPT) (- Y2 OPT KROM))
	BM  (GETVAR "BLIPMODE")
  )
  (SETVAR "OSMODE" 0)
  (SETVAR "BLIPMODE" 0)
  
  (command "-layer" "M" "AC-1500-WAPENING-co-70" "C" "4" "" "Lt" "continuous" "" "S" "" "") ;        command "-layer" "M" "AC-1530-SNEDEWAPENING-co-70" "C" "4" "" "Lt" "continuous" "" "S" "" ""
(if (> HL 0)
  (COMMAND "PLINE"
   	   RB11
	   "W"
	   "0"
	   ""
	   RB12
	   "a"
	   RB13
	   "l"
	   RO1
	   "a"
	   RO2
	   "l"
	   LO1
	   "a"
	   LO2
	   "l"
	   LB1
	   "a"
	   LB2
	   "l"
	   RB21
	   "a"
	   RB22
	   "l"
	   RB23
	   	   ""
  )
  (COMMAND "PLINE"
   	   LB2
	   "W"
	   "0"
	   ""
	   RB1
	   "a"
	   RB2
	   "l"
	   RO1
	   "a"
	   RO2
	   "l"
	   LO1
	   "a"
	   LO2
	   "l"
	   LB1
	   "a"
	   LB2
	   	   ""
  )
  )
  (SETQ	X3   (+ X1 OPT (/ BD 2.0) (* schaal 0.4))		;vareabele die x positie van donut opslaat (veranderlijk)
	Y3   (- Y2 OPT (/ BD 2.0) (* schaal 0.4))		;vareabele die y positie van donut opslaat (veranderlijk)
	X4   (- X2 OPT (/ BD 2.0) (* schaal 0.4))
	Y4   (- Y2 OPT (/ BD 2.0) (* schaal 0.4))
	X5   (+ X1 OPT (/ OD 2.0) (* schaal 0.4))		;vareabele die x positie van donut opslaat (veranderlijk)
	Y5   (+ Y1 OPT (/ OD 2.0) (* schaal 0.4))		;vareabele die y positie van donut opslaat (veranderlijk)
	X6   (- X2 OPT (/ OD 2.0) (* schaal 0.4))
	Y6   (+ Y1 OPT (/ OD 2.0) (* schaal 0.4))
	X7   (+ X1 OPT (/ FD 2.0) (* schaal 0.4))
	X8   (- X2 OPT (/ FD 2.0) (* schaal 0.4))
	PNT3 (LIST X3 Y3)
	PNT4 (LIST X4 Y4)
	PNT5 (LIST X5 Y5)
	PNT6 (LIST X6 Y6)
	HAB  (DISTANCE PNT3 PNT4) 				;horizontale afstand tussen centerpunten uiterste donuts
	HAO  (DISTANCE PNT5 PNT6)
	VA   (abs (-(abs (cadr PNT3))(abs (cadr PNT5)))) 	;verticale afstand tussen centerpunten uiterste donuts
  )
  (command "-layer" "M" "AC-1530-SNEDEWAPENING-co-70" "C" "4" "" "Lt" "continuous" "" "S" "" "") ;        command "-layer" "M" "AC-1530-SNEDEWAPENING-co-70" "C" "4" "" "Lt" "continuous" "" "S" "" ""

  (IF (> AB 0)	;functie die bovenwapening tekent
    (PROGN
      (setq x x3)
      (COMMAND "donut" 0 BD)
      (SETQ HTB  (/ HAB (- AB 1)))		;horizontale afstand tussen staven bovenwapening 
      (REPEAT AB
	(COMMAND (LIST X Y3))
	(SETQ X (+ X HTB))
      ) ; einde repeat
      (COMMAND "")
    ) ; einde progn
  ) ; einde if
  
  (IF (> AO 0)	;functie die onderwapening tekent
    (PROGN
      (setq x x5)
      (SETQ HTO  (/ HAO (- AO 1)))		;horizontale afstand tussen staven onderwapening 
      (COMMAND "donut" 0 OD)
      (REPEAT AO
	(COMMAND (LIST X Y6))
	(SETQ X (+ X HTO))
      ) ; einde repeat
      (COMMAND "")
    ) ; einde progn
  ) ; einde if
  
  (IF (> AF 0)
    (PROGN
      (SETQ VTZ	(/ VA (+ AF 1))		;verticale afstand tussen zijwapening
	    Y	(- Y3 VTZ)
      	    X 	X7
      )
      (command "-layer" "M" "AC-1530-SNEDEWAPENING-co-70" "C" "4" "" "Lt" "continuous" "" "S" "" "")
      (COMMAND "donut" 0 FD)      
      (REPEAT AF
	(COMMAND (LIST X7 Y))
	(COMMAND (LIST X8 Y))
;	(COMMAND "")
	(SETQ Y (- Y VTZ))
      ) ; einde repeat
      (COMMAND "")
    ) ; einde progn
  ) ; einde if
  (SETVAR "BLIPMODE" BM)
  (princ af)
  (SETVAR "OSMODE" snapie)
;  (COMMAND "STYLE" "" "" "0" "" "" "" "" "")
) ; einde bgl

;**************************************************************************************************************
;Schalen van iets maar ik weet niet wat
(DEFUN C:SCLD ()
  (SETQ SELSET (SSGET)) ;	selectieset van elementen
  (IF SELSET
    (PROGN
      (SETQ SELAAN (SSLENGTH SELSET)
	    TELLER 0
	    FAKTOR (GETREAL "\nWelke faktor : ")
      )
      (WHILE (< TELLER SELAAN)
	(SETQ NAAM (SSNAME SELSET TELLER)
	      GEG  (ENTGET NAAM)
	)
	(IF (= (CDR (ASSOC 0 GEG)) "POLYLINE")
	  (PROGN
	    (SETQ NAAM1	(ENTNEXT NAAM)
		  GEG1	(ENTGET NAAM1)
		  NAAM2	(ENTNEXT NAAM1)
		  GEG2	(ENTGET NAAM2)
	    )
	    (IF
	      (AND (= (CDR (ASSOC 0 (ENTGET (ENTNEXT NAAM2)))) "SEQEND")
		   (OR (= (CDR (ASSOC 42 GEG1)) 1.0)
		       (= (CDR (ASSOC 42 GEG1)) -1.0)
		   )
		   (OR (= (CDR (ASSOC 42 GEG2)) 1.0)
		       (= (CDR (ASSOC 42 GEG2)) -1.0)
		   )
	      )
	       (COMMAND
		 "SCALE"
		 NAAM
		 ""
		 (OSNAP (TRANS (CDR (ASSOC 10 GEG1)) NAAM 1) "CENTER")
		 FAKTOR
	       )
	    ) ; einde if
	  )
	) ; einde progn en if
	(SETQ TELLER (+ TELLER 1))
      ) ; einde while
    ) ; einde progn
    (princ "\nNIETS in selektieset ...... ")
  ) ; einde if
  (prin1)
) ; einde defun

;**************************************************************************************************************

; tekent pijl naar beugels met text: BGLS Øx
  
(defun C:BGLP ()
  (setvar "CMDECHO" 0)

  (initget 1)
  (SETVAR "OSMODE" 512)
  (setq pnt (getpoint "\nEindpunt pijl : NEArest to "))
  (initget 1)
  (SETVAR "OSMODE" 0)
  (setq	hoek   (getangle pnt "  Richting : ")
	teksch (getvar "DIMSCALE")
	pdiam  (inget "  Diameter " pdiam)
	pyltxt (strcat "BGLS " "%%c" (itoa pdiam))
  )

  ;(command "style" "" "" "0" "" "" "" "" "")
  ;bgl(COMMAND "LAYER" "s" "WAPTXT" "")

  (if (> hoek (/ pi 2))
    (command "text"
	     "C"
	     (polar (polar pnt hoek (* teksch 13))
		    (- hoek (/ pi 2))
		    (* teksch 1)
	     )
	     (* teksch 2.5)
	     (angtos (- hoek pi) 0 4)
	     pyltxt
    )
    (command "text"
	     "C"
	     (polar (polar pnt hoek (* teksch 13))
		    (+ hoek (/ pi 2))
		    (* teksch 1)
	     )
	     (* teksch 2.5)
	     (angtos hoek 0 4)
	     pyltxt
    )
  )

  (command "pline"
	   pnt
	   "w"
	   "0"
	   (* teksch 1.5)
	   (polar pnt hoek (* teksch 4))
	   "w"
	   "0"
	   "0"
	   (polar pnt hoek (* teksch 22))
	   ""
  )

) ; einde defun bglpyl

;**************************************************************************************************************

; Functie die tussen 2 donuts x aantal tussendonuts tekent
(DEFUN C:BGLD () 
  (PRINC "Tekenen van meerdere donuts op een rijtje ...")
  (SETQ PNT1 NIL)

  (WHILE (NOT PNT1)
    (SETQ PNT1 (ENTSEL "\nSelekteer donut 1  : "))
  )

  (SETQ	PNT2 NIL
	PNT2 (ENTSEL "\n(RETURN voor h.o.h.) Selekteer donut 2  : ")
	NAAM (CAR PNT1)
	PNT1 (OSNAP (CADR PNT1) "CENTER")
  )

  (IF PNT2

    (SETQ PNT2 (OSNAP (CADR PNT2) "CENTER")
	  AFST (DISTANCE PNT1 PNT2)
	  AANT (GETINT "\nTot. aantal staven : ")
	  AANT (- AANT 1)
	  AFST (princ (/ AFST AANT))
    )

    (SETQ PNT2 (GETPOINT PNT1 "\nRichting : ")
	  AFST (AFGET "  h.o.h. afstand : " AFST)
	  AANT (+ 2 (FIX (/ (DISTANCE PNT1 PNT2) AFST)))
    )
  )

  (SETQ HOEK (ANGLE PNT1 PNT2))
  (COMMAND "UCS" "Z" (ANGTOS HOEK 0 4))
  (COMMAND "ARRAY" NAAM "" "R" "1" AANT AFST)
  (COMMAND "UCS" "P")
  (PRIN1)
) ; einde defun

(prin1)
 ;  ******** E i n d e  b l o k   BGLWAP ********
