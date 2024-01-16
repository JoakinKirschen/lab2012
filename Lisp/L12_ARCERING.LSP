;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_ARCERING ()
(princ "L12_ARCERING is loaded")
(princ)
)

;;-----[ Functie die arcering toggle pickpoint select objects tekent]-------------------------

  (defun C:Arct ( / arctoggle)
  (initerr)  (setvar "cmdecho" 0)
    (if	(= arctoggle "1")
      (progn (setq arctoggle "0") (princ "\nSelect objects activated"))
      (progn (setq arctoggle "1") (princ "\nPickpoints activated"))
    )
  (reset)
  )


;;-----[ Functie die arcering solid tekent]-------------------------

  (defun C:Maakarcsolid ( / hatch sc schaal )
    (initerr)  
    (setvar "cmdecho" 0)
    (setq hatch "solid")
    (setq schaal (L12_getschaal))
	(if (= schaal 1)
    (setvar "hpscale" 1)
    (setvar "hpscale" (/ schaal 4))
    )
    (setq sc (/ schaal 4))
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering ANSI37 tekent]-------------------------

  (defun C:Maakarcansi37 ( / hatch sc schaal )
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "Ansi37")
    (setq schaal (L12_getschaal))
	(if (= schaal 1)
    (setvar "hpscale" 1)
    (setvar "hpscale" (/ schaal 2))
    )    
    (setq sc (/ schaal 2))
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering ANSI31 tekent]-------------------------

  (defun C:Maakarcansi31 ( / hatch sc schaal )
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "Ansi31")
    (setq schaal (L12_getschaal))
	(if (= schaal 1)
    (setvar "hpscale" 1)
    (setvar "hpscale" (/ schaal 2))
    )    
    (setq sc (/ schaal 2))
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering ANSI32 tekent]-------------------------

  (defun C:Maakarcansi32 ( / hatch sc schaal)
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "Ansi32")
    (setq schaal (L12_getschaal))
	(if (= schaal 1)
      (setvar "hpscale" 1)
      (setvar "hpscale" (/ schaal 2))
    )    
    (setq sc (/ schaal 2))
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering Brick tekent]-------------------------

  (defun C:Maakarcbrick ( / hatch sc schaal)
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "Brick")
    (setq schaal (L12_getschaal))
	(if (= schaal 1)
      (setvar "hpscale" 1)
      (setvar "hpscale" (/ schaal 4))
    )    
    (setq sc (/ schaal 4))
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering Conc tekent]-------------------------

  (defun C:Maakarcconc ( /  hatch sc schaal)
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "ar-conc")
    (setq schaal (L12_getschaal))
	(if (= schaal 1)
      (setvar "hpscale" 1)
      (setvar "hpscale" (/ schaal 4))
    )    
    (setq sc "1")
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering Sand tekent]-------------------------

  (defun C:Maakarcsand ( /  hatch sc schaal)
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "ar-sand")
    (setq schaal (L12_getschaal))
	(if (= schaal 1)
      (setvar "hpscale" 1)
      (setvar "hpscale" (/ schaal 4))
    )    
    (setq sc "1")
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering Traan tekent]-------------------------

  (defun C:Maakarctraan ( /  hatch sc schaal)
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "flex")
    (setq schaal (L12_getschaal))
    (if (= schaal 1)
      (setvar "hpscale" 1)
      (setvar "hpscale" (/ schaal 4))
    )    
    (setq sc (/ schaal 4))
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering Angle tekent]-------------------------

  (defun C:Maakarcangle ( /  hatch sc schaal)
   (initerr)  (setvar "cmdecho" 0)
    (setq hatch "Angle")
    (setq schaal (L12_getschaal))
    (if (= schaal 1)
      (setvar "hpscale" 1)
      (setvar "hpscale" (/ schaal 4))
    )
    (setq sc (/ schaal 4))
	(reset)
	(L12_maakarc hatch sc)
  )


;;-----[ Functie die arcering tekent]-------------------------

  (prompt "\n(MAAKARC)     Functie die arcering tekent")
  (defun L12_maakarc ( hatch sc / layName lp color c2 baseLayName incolor hatch sc )
    (initerr)  (setvar "cmdecho" 0)
    (setq baseLayName "0500-ARCERING")
    (setq c2 (getvar "clayer"))
    ;; Vastleggen Color
     (Cond
       ((= ccCurColor "1") (setq incolor "06"))
       ((= ccCurColor "3") (setq incolor "12"))
       ((= ccCurColor "7") (setq incolor "25"))
       ((= ccCurColor "2") (setq incolor "35"))
       ((= ccCurColor "6") (setq incolor "50"))
       ((= ccCurColor "4") (setq incolor "70"))
       ((= ccCurColor "5") (setq incolor "90"))
       ((= ccCurColor "8") (setq incolor "Grijs"))
     );cond
    (setq layName (Strcat baseLayName "-" incolor))

    (L12_standard_maakarc layName ccCurColor) 
   
   ;; Aanmaken layer indien hij nog niet bestaat
  (if (= arctoggle "1")    
    (if (= hatch "solid")
      (command "._-BHATCH" "DR" "B" "P" "S"	       "A" "A" "Y" "S" "O" "G" "10" "H" "N" "" )
      (command "._-BHATCH" "DR" "B" "P" hatch sc "0" "A" "A" "Y" "S" "O" "G" "10" "H" "N" "" )
    )
    (if (= hatch "solid")
      (command "._-BHATCH" "DR" "B" "P" "S"	       "A" "A" "Y" "S" "O" "G" "10" "H" "N" "" "s")
      (command "._-BHATCH" "DR" "B" "P" hatch sc "0" "A" "A" "Y" "S" "O" "G" "10" "H" "N" "" "s")
    )
  )
  (setq lp 1)
  (while lp
    (if	(> (getvar "cmdactive") 0)
      (command pause)
      (setq lp nil)
    )
  )
  (reset)
  (princ)
  )


;;-----[ Functie die de omtrek van een arcering tekent]-------

  (prompt  "\n(MAAKOMTREK)  Functie die de omtrek van een arcering tekent" )
  
  (defun C:maakomtrek ( / strLay schaal c2  )
    (initerr)  
    (setvar "cmdecho" 0)
    (setq schaal (L12_getschaal))
    (setq c2 (getvar "clayer"))
	(L12_standard_maakomtrek)
    (princ (strcat "\nCurrent Layer: " strLay "\n"))
	(reset)
    (princ)
  ) ;defun maakomtrek
