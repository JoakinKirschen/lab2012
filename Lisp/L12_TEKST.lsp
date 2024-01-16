;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_TEKST ()
(princ "L12_TEKST is loaded")
(princ)
)

(prompt "\n(ZETTEKST)    Functie die tekst zet")

;;-----[ Functie die tekst zet]-------------------------------
(defun L12_tekstmodus (/)
	(command ".-style" "Standard" "isocpeur" "" "1" "" "" "")
)

(defun zettekst (tkstgro tekst layern / schaal c1 pt color teksth hoogte box )
    (initerr)  
	(setvar "cmdecho" 0)
	(needupdate)
    (setq schaal (L12_getschaal)) 
	(L12_tekstmodus)
    (princ "\n ")
    (setq pt(getpoint "\nStart point of text: "))
    (princ "\n ")
    (setq c1 (getvar "clayer"))
    ;; Vastleggen LineType CODE
	(L12_standard_zettekststyle)
   (Cond 
	  ((= tkstgro "1.8") (setq color "3"))
      ((= tkstgro "2.5") (setq color "7"))
      ((= tkstgro "3.0") (setq color "2"))
      ((= tkstgro "5.0") (setq color "6"))
      ((= tkstgro "7.0") (setq color "4")) 
      ((= tkstgro "9.0") (setq color "5"))
      (nil (setq color "7"))
      ((not nil) (setq color "7"))
    )
    (setq teksth (atof tkstgro))
    (setq hoogte (* teksth schaal))
	
	(L12_standard_zettekstlayer layern tekst color)
    (setq box (strcat "@" "0" "," (rtos hoogte)))
    (command "_.mtext" pt "_height" hoogte box "" "")
    (command "_.mtedit"(entlast))
    (command "layer" "s" c1 "")
	(reset)
    (princ)
  )    ;defun zettekst
  
  (defun C:zettekst25 ( / tkstgro tekst layern )
    (initerr)  
	(setvar "cmdecho" 0)
    (setq tkstgro "2.5")
    (setq tekst "25")
    (setq layern "0300-TEKST-")
    (zettekst tkstgro tekst layern )
	(reset)
	(princ)
  )
  
  (defun C:zettekst30 ( / tkstgro tekst layern )
    (initerr)  
	(setvar "cmdecho" 0)
    (setq tkstgro "3.0")
    (setq tekst "30")
    (setq layern "0300-TEKST-")
    (zettekst tkstgro tekst layern )
	(reset)
	(princ)
  )
  
  (defun C:zettekst50 ( / tkstgro tekst layern )
    (initerr)  
	(setvar "cmdecho" 0)
    (setq tkstgro "5.0")
    (setq tekst "50")
    (setq layern "0300-TEKST-")
    (zettekst tkstgro tekst layern )
	(reset)
  )
  
  (defun C:zettekst70 ( / tkstgro tekst layern )
    (initerr)  
	(setvar "cmdecho" 0)
    (setq tkstgro "7.0")
    (setq tekst "70")
    (setq layern "0300-TEKST-")
    (zettekst tkstgro tekst layern )
	(reset)
	(princ)
  )

  (defun C:deurnr ( / tkstgro tekst layern start verdiep pt osm schaal )
    (initerr)  
	(setvar "cmdecho" 0)
    (setq schaal (L12_getschaal))
    (princ "\n ")
    (setq tkstgro "30")
	(setq tekst "3.0")
    (setq osm (getvar "osmode"))
    (setq layern "AC-0300-TEKST-")
	(mfixlayer (strcat layern tkstgro) "5" "continuous" "default" 1)
    (setq start (getint "\nGeef het beginnummer:"))
    (setq verdiep (getint "\nGeef het verdiepingsnummer:"))
	(setq prestr (getstring T "\nGeef voorvoegsel:"))
	(L12_tekstmodus)
    (while
      (setq pt (getpoint (strcat prestr (rtos verdiep) "." (rtos start) )))
      (setvar "osmode" 0)
      (setq tekst (strcat prestr (rtos verdiep) "." (rtos start)))
      (command "_.mtext" pt "_height" (* schaal 3.0) (strcat "@" (rtos (* schaal 15)) "," (rtos (* schaal 3.5))) tekst "")
      (setvar "osmode" osm)
      (setq start (+ start 1))
    )
       (setvar "osmode" osm)
	   (reset)
	   (princ)
  )
  
  (defun C:paalnr ( / tkstgro tekst layern start verdiep pt osm schaal )
    (initerr)  (setvar "cmdecho" 0)
    (setq schaal (L12_getschaal))
    (princ "\n ")
    (setq tkstgro "50")
	(setq tekst "5.0")
    (setq osm (getvar "osmode"))
    (setq layern "0300-TEKST-")
	(mfixlayer (strcat layern tkstgro) "6" "continuous" "default" 1)
    (setq start (getint "\nGeef het beginnummer:"))
	(L12_tekstmodus)
    (while
      (setq pt (getpoint (strcat "\nP" (rtos start))))
      (setvar "osmode" 0)
      (setq tekst (strcat "P"(rtos start)))
      (command "_.mtext" pt "_height"  (* schaal 5)  (strcat "@" (rtos (* schaal 15)) "," (rtos (* schaal 5))) tekst "")
      (setvar "osmode" osm)
      (setq start (+ start 1))
    )
    (setvar "osmode" osm)
	(reset)
  )
  
  ;;-----[ Functie voor wapening aanduiding]--------------------
  
  (defun ccwaptxt ( / )
    (setq schaal (L12_getschaal))
    (command "dimstyle" "R" "STIJL B")
	(mfixlayer "2930-WAPEN-AANDUIDING" "7" "continuous" "default" 1)
    (command "qleader")
	(princ)
  ) ; defun
 

;;-----[ Functie die spaties achteraan een string verwijderd]

  (prompt
    "\n(TRIM)        Functie die spaties achteraan een string verwijdert"
  )
  
  (defun TRIM (DATA / maxs count chrct string)
    (if data    ;if the size has been found
      (progn
        (setq maxs   (strlen data)	;establish length of input
          count  1
          chrct  1    ;initialize count and char position
          string (substr data count 1)
        )    ;setq
        (setq count (1+ count))
        (while (< count maxs)    ;process string one chr at a time
          (if (/= " " (setq char (substr data count 1)))    ;look for the commas
            (setq chrct (1+ chrct)    ;increment to next pos
                  string (strcat string char)
            )  ;setq
            (setq chrct 1);                            ;resets field ct
          )    ;if
          (setq count (1+ count))	;increment the counter
        )   ;while
      )    ;progn
    )    ;if data
    STRING
  )    ;trim



