;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_TEKEN ()
(princ "L12_TEKEN is loaded")
(princ)
)

;make layer functie van breuklijn verhuizen van cui naar lisp

;;-----[ Functie die scopecirkels tekent ]--------------------

  (Defun C:CLDOTS (/ Arc_sm Arc_big c1 schaal)
	(c:ai_selall)
	(command *Cancel*)
	(command "erase" "p" "remove")
  )

  (prompt     "\n(C:REVCL)     Functie die scopecirkels tekent"  )

  (Defun C:REVCL (/ Arc_sm Arc_big c1 schaal)
    (setq schaal (L12_getschaal))
   (initerr)  (setvar "cmdecho" 0)
	(setq c1 (getvar "clayer"))
    (setq Arc_sm (* schaal 5))
    (setq Arc_big (* schaal 7))
	(L12_standard_REVCL)
    (command "revcloud" "a" Arc_sm Arc_big)
	(while (= (logand (getvar "CMDACTIVE") 1) 1)
      (command pause)
    )
	(setvar "clayer" c1 )
	(reset)
	(princ)
  )

;;-----[ Functie die een viewport aanmaakt]-------------------

  (prompt "\n(MAAKVIEW)    Functie die een viewport aanmaakt" )
  
  (defun c:maakview ( / c2 p1 p2 )
   (initerr)  (setvar "cmdecho" 0)
	(if (= (getvar "TILEMODE") 0)
	(progn
    (L12_checkinstel)
    (setq c2 (getvar "clayer"))
	(setq p1 (getpoint "Geef beginpunt"))
	(setq p2 (getcorner p1 "Geef beginpunt"))
	(L12_standard_maakview)
    (command "-vports" p1 p2)
	(setvar "clayer" c2)
	)
	(alert "Wrong view!")
	)
    (reset)
	(princ)
  ) ;defun maakview
  
;;-----[ Functie die een aslijn tekent]-----------------------

  (prompt "\n(ASLIJN)      Functie die een aslijn tekent")
  
  (defun aslijn (baseLayName colname / strLay )
    (needupdate)
    (initerr)  (setvar "cmdecho" 0)
	(L12_checkinstel)
	(cond 
      ((= colname "1")           (setq strLay (strcat baseLayName "-dd-06"))	  )
      ((= colname "3")           (setq strLay (strcat baseLayName "-dd-12"))	  )
    )
	(reset)
	(L12_standard_aslijn strLay ColName)
    (princ)
  ) ;defun aslijn


  
(defun C:Opening ( / schaal ipt1 ipt2 ipt1x ipt1y ipt2x ipt2y alpha len   lijstje counter cosalp sinalp   iptsX iptsY)
    (initerr)
	(setvar "cmdecho" 0)
    (setq schaal (L12_getschaal))
    (setq ipt1 (getpoint "\ngeef beginpunt"))
    (setq ipt2 (getpoint ipt1 "\ngeef eindpunt"))
    (if (and (/= ipt1 nil)(/= ipt2 nil))
     (progn
        (setq ipt1X (car ipt1)
              ipt1Y (cadr ipt1)
			  ipt2X (car ipt2)
              ipt2Y (cadr ipt2)
              len   (* (distance ipt1 ipt2) 0.1)
			  lijstje (list ())
			  lijstje2 (list ())
			  counter 1
		)
	 ;p1
	 
	 (if (< ipt1X ipt2X)
	 (progn (setq iptsX ipt1X) (setq iptbX ipt2X))
	 (progn (setq iptsX ipt2X) (setq iptbX ipt1X))
	 )
	 
	 (if (< ipt1Y ipt2Y)
	 (progn (setq iptsY ipt1Y) (setq iptbY ipt2Y))
	 (progn (setq iptsY ipt2Y) (setq iptbY ipt1Y))
	 )
	 
	 (setq ipt1 (list iptsX iptsY))
	 (setq ipt2 (list iptbX iptbY))
	 
	 (setq 
	 alpha (angle ipt1 ipt2)
	 cosalp (cos alpha)
	 sinalp (sin alpha)
	 )
	 
	 (setq lijstje (cons (list iptsX iptsY) lijstje))
	 (setq lijstje (cons (list iptsX iptbY) lijstje))
	 (setq lijstje (cons (list iptbX iptbY) lijstje))
	 (setq lijstje (cons (list iptbX iptsY) lijstje))
	 ;tussenpunten
	 
	 (setq lijstje(cons (list iptsX iptsY) lijstje))
	 (setq lijstje(cons (list (+ iptsX (* (cos alpha) len)) (- iptbY (* (sin alpha) len))) lijstje))
	 (setq lijstje(cons (list iptbX iptbY) lijstje))
	 
	 ;(setq lijstje (cons lijstje2 lijstje))
	 
	 ;(setvar "aunits" 3)
	 (setvar "osmode" 0)
	 (command "_.pline")
     (mapcar 'command lijstje)
	 ;(mapcar 'command lijstje2)
	 ;(command "_c")
	 
	;(command "_.rotate" (entlast) "" ipt1 alpha)
	 )
     )
	 (command "._-BHATCH" "DR" "B" "P" "S"	       "A" "A" "Y" "S" "O" "G" "10" "H" "N" "" (list (+ iptsX (* (cos alpha) len)) (- iptbY (* (sin alpha) len))) )
    (reset)
	(princ)
)
  
  
;;-----[ Functie die breuklijn tekent]------------------------
; cons adds value to a list

(defun C:Breuklijn ( / schaal ipt1 ipt2 ipt1x ipt1y ipt2x ipt2y alpha len am d_len lijstje counter cosalp sinalp refpuntx refpunty)
    (initerr)
	(setvar "cmdecho" 0)
    (setq schaal (L12_getschaal))
    (setq ipt1 (getpoint "\ngeef beginpunt"))
    (setq ipt2 (getpoint ipt1 "\ngeef eindpunt"))
    (if (and (/= ipt1 nil)(/= ipt2 nil))
     (progn
        (setq ipt1X (car ipt1)
              ipt1Y (cadr ipt1)
			  ipt2X (car ipt2)
              ipt2Y (cadr ipt2)
              alpha (angle ipt1 ipt2)
              len   (distance ipt1 ipt2)
			  am	(fix (/ len (* schaal 6) ))
			  lijstje (list ())
			  counter 1
			  cosalp (cos alpha)
			  sinalp (sin alpha)
		)
	 (if (< am 2) 
	 (progn 
	 (setq am 2) 
	 ))
	 (setq d_len(/ len am))
	 ;p1
	 (setq lijstje (cons (list (- ipt1X (* (* schaal 2) cosalp)) (- ipt1Y (* (* schaal 2) sinalp))) lijstje))
	 ;tussenpunten
	 (while (> am counter)
     (setq refpuntx (+ ipt1X (*(* d_len counter)cosalp)))
	 (setq refpunty (+ ipt1Y (*(* d_len counter)sinalp)))
	 (setq lijstje (cons (list (- refpuntx (* schaal cosalp)) (- refpunty (* schaal sinalp))) lijstje))
	 (setq lijstje (cons (list (-(- refpuntx (* (/ schaal 2) cosalp)) (* schaal sinalp)) (+(- refpunty (* (/ schaal 2) sinalp)) (* schaal cosalp))) lijstje))
	 (setq lijstje (cons (list (+(+ refpuntx (* (/ schaal 2) cosalp)) (* schaal sinalp)) (-(+ refpunty (* (/ schaal 2) sinalp)) (* schaal cosalp))) lijstje))
	 (setq lijstje (cons (list (+ refpuntx (* schaal cosalp)) (+ refpunty (* schaal sinalp))) lijstje))
	 (setq counter (+ counter 1))
	 )
	 ;laatste punt
	 (setq lijstje (cons (list (+ ipt2X (* (* schaal 2) cosalp)) (+ ipt2Y (* (* schaal 2) sinalp))) lijstje))
	 (L12_standard_Breuklijn)
	 ;(setvar "aunits" 3)
	 (setvar "osmode" 0)
	 (command "_.pline")
     (mapcar 'command lijstje)
	;(command "_c")
	;(command "_.rotate" (entlast) "" ipt1 alpha)
	 )
     )
    (reset)
	(princ)
)