(defun L12_STANDARD ()
(princ "L12_STANDARD is loaded")
(princ)
)

(defun L12_STANDARD_LIST ()
(setq a (list "Sweco" "Undefined" "AMG" "Trinseo-BE" "Trinseo-NL"))
a
)

(defun L12_standard_instel () ;L12_instel
(cond
	((= (L12_getstandard) 1)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
	((= (L12_getstandard) 2)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
	((= (L12_getstandard) 3)
		(progn 
			(Steal (findfile "arcelor_alg.dwt") '(("Layers" ("*"))))
			(command "-style" "Arcelor" "isocpeur" "" "1" "" "" "")
		)
	)
	((= (L12_getstandard) 4)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
	((= (L12_getstandard) 5)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
)
)

(defun L12_standard_mfixLayer ( / discipline) ;L12_instel
(setq discipline "")
(Cond
	((= (L12_getstandard) 1)(setq discipline (getenv "L12_Disipline")))
	((= (L12_getstandard) 2)(setq discipline (getenv "L12_Disipline")))
	((= (L12_getstandard) 3)(setq discipline ""))
	((= (L12_getstandard) 4)(setq discipline (getenv "L12_Disipline")))
	((= (L12_getstandard) 5)(setq discipline (getenv "L12_Disipline")))
)
discipline
)

(defun L12_standard_maakarc (layName ccCurColor / layName)
(Cond
	((= (L12_getstandard) 1) (progn(mfixLayer layName ccCurColor "continuous" "default" 1)))
	((= (L12_getstandard) 2) (progn(mfixLayer layName ccCurColor "continuous" "default" 1)))
	((= (L12_getstandard) 3) (progn(mfixLayer "Hatch18C" "4" "continuous" 0.18 1)))
	((= (L12_getstandard) 4) (progn(mfixLayer layName ccCurColor "continuous" "default" 1)))
	((= (L12_getstandard) 5) (progn(mfixLayer layName ccCurColor "continuous" "default" 1)))
)
)

(defun L12_standard_maakomtrek ( / )
(Cond
	((= (L12_getstandard) 1) (mfixLayer "0500-ARCERING-OMTREK-co-06" "1" "continuous" "default" 1))
	((= (L12_getstandard) 2) (mfixLayer "0500-ARCERING-OMTREK-co-06" "1" "continuous" "default" 1))
	((= (L12_getstandard) 3) (mfixLayer "Hatch18C" "4" "continuous" 0.18 1))
	((= (L12_getstandard) 4) (mfixLayer "0500-ARCERING-OMTREK-co-06" "1" "continuous" "default" 1))
	((= (L12_getstandard) 5) (mfixLayer "0500-ARCERING-OMTREK-co-06" "1" "continuous" "default" 1))
)
)

(defun L12_standard_BInsertScLaEx ( / prestring)
	(setq prestring "")
	(Cond
		((= (L12_getstandard) 1)(progn(mfixLayer "0300-TEKST-35" "2" "continuous" "default" 1)))
		((= (L12_getstandard) 2)(progn(mfixLayer "0300-TEKST-35" "2" "continuous" "default" 1)))
		((= (L12_getstandard) 3)(progn(mfixLayer "TEKST" "7" "continuous" "default" 1)(setq prestring "AMG_")))
		((= (L12_getstandard) 4)(progn(mfixLayer "0300-TEKST-35" "2" "continuous" "default" 1)))
		((= (L12_getstandard) 5)(progn(mfixLayer "0300-TEKST-35" "2" "continuous" "default" 1)(setq prestring "Trinseo-NL_")))
	)
	prestring
)

(defun L12_standard_BInsertScLa ( / prestring)
	(Cond
		((= (L12_getstandard) 1)(setq prestring ""))
		((= (L12_getstandard) 2)(setq prestring ""))
		((= (L12_getstandard) 3)(setq prestring "AMG_"))
		((= (L12_getstandard) 4)(setq prestring ""))
		((= (L12_getstandard) 5)(setq prestring "Trinseo-NL_"))
	)
	prestring
)

(defun L12_standard_BInsertStramienaanduiding ( / )
	(Cond
		((= (L12_getstandard) 1) (mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 ))
		((= (L12_getstandard) 2) (mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 ))
		((= (L12_getstandard) 3) (mfixLayer "Text" "7" "continuous" "default" 1 ))
		((= (L12_getstandard) 4) (mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 ))
		((= (L12_getstandard) 5) (mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 ))
	)
	
)

(defun L12_standard_kader ( / )
	(Cond
		((= (L12_getstandard) 1)(progn
		(mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 )
		(BInsertScaled kader ipt)
		))
		((= (L12_getstandard) 2)(progn
		(mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 )
		(BInsertScaled kader ipt)
		))
		((= (L12_getstandard) 3)(progn
		(setvar "clayer" "0" )
		(BInsertScaledEx (strcat "AMG_" kader) ipt)
		))
		((= (L12_getstandard) 4)(progn
		(mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 )
		(BInsertScaled (strcat "Trinseo_" kader) ipt)
		))
		((= (L12_getstandard) 5)(progn
		(mfixLayer "0100-SYMBOOL-co-25" "7" "continuous" "default" 1 )
		(BInsertScaled (strcat "Trinseo_" kader) ipt)
		))
	)
)

(defun L12_standard_DimStijl ( / )
	(Cond
		((= (L12_getstandard) 1)(setvar "dimclrt" 2))
		((= (L12_getstandard) 2)(setvar "dimclrt" 2))
		((= (L12_getstandard) 3)(setvar "dimclrt" 256))
		((= (L12_getstandard) 4)(setvar "dimclrt" 2))
		((= (L12_getstandard) 5)(setvar "dimclrt" 2))
	)
)

(defun L12_standard_drawdim ( / )
	(Cond
		((= (L12_getstandard) 1)(mfixLayer "0200-MAAT" "7" "continuous" "default"   1))
		((= (L12_getstandard) 2)(mfixLayer "0200-MAAT" "7" "continuous" "default"   1))
		((= (L12_getstandard) 3)(mfixLayer "Dim25C" "2" "continuous" 0.25   1))
		((= (L12_getstandard) 4)(mfixLayer "0200-MAAT" "7" "continuous" "default"   1))
		((= (L12_getstandard) 5)(mfixLayer "0200-MAAT" "7" "continuous" "default"   1))
	)
)

(defun L12_standaard_getctb (PlName / Pltemp)
  (setq Pltemp "")
  (cond
	  ((= (L12_getstandard) 1)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "A3 - afd. 01 pendiktes met grijswaarden.ctb") 
		(setq Pltemp "Afdeling 01 pendiktes met grijswaarden.ctb")
		)
	  )
	  ((= (L12_getstandard) 2)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "Alles dun 010.ctb") 
		(setq Pltemp "Alles dun 025.ctb")
		)
	  )
	  ((= (L12_getstandard) 3)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "arcelor_black.ctb") 
		(setq Pltemp "arcelor_black.ctb")
		)
	  )
	 ((= (L12_getstandard) 4)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "A3 - afd. 01 pendiktes met grijswaarden.ctb") 
		(setq Pltemp "Afdeling 01 pendiktes met grijswaarden.ctb")
		)
	  )
	 ((= (L12_getstandard) 5)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "A3 - afd. 01 pendiktes met grijswaarden.ctb") 
		(setq Pltemp "Afdeling 01 pendiktes met grijswaarden.ctb")
		)
	  )
	  ((= (L12_getstandard) nil)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "Alles dun 010.ctb") 
		(setq Pltemp "Alles dun 025.ctb")
		)
	  )  
  )
  Pltemp
)

(defun L12_standaard_getctbcol (PlName / Pltemp)
  (setq Pltemp "")
  (cond
	  ((= (L12_getstandard) 1)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "A3 - afd. 01 pendiktes met grijswaarden col.ctb") 
		(setq Pltemp "Afdeling 01 pendiktes met grijswaarden col.ctb")
		)
	  )
	  ((= (L12_getstandard) 2)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "Alles kleur.ctb") 
		(setq Pltemp "Alles kleur.ctb")
		)
	  )
	  ((= (L12_getstandard) 3)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "arcelor_color.ctb") 
		(setq Pltemp "arcelor_color.ctb")
		)
	  )
	  ((= (L12_getstandard) 4)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "A3 - afd. 01 pendiktes met grijswaarden col.ctb") 
		(setq Pltemp "Afdeling 01 pendiktes met grijswaarden col.ctb")
		)
	  )
	  ((= (L12_getstandard) 5)
		(if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3")) 
		(setq Pltemp "A3 - afd. 01 pendiktes met grijswaarden col.ctb") 
		(setq Pltemp "Afdeling 01 pendiktes met grijswaarden col.ctb")
		)
	  )
  )
  Pltemp
)

(defun L12_standaard_Statusb ( / )
(setq statussta "-")
	(Cond
	((= (L12_getstandard) 0) (setq statussta "-"))
	((= (L12_getstandard) 1) (setq statussta (nth 0 (L12_STANDARD_LIST))))
	((= (L12_getstandard) 2) (setq statussta (nth 1 (L12_STANDARD_LIST))))
	((= (L12_getstandard) 3) (setq statussta (nth 2 (L12_STANDARD_LIST))))
	((= (L12_getstandard) 4) (setq statussta (nth 3 (L12_STANDARD_LIST))))
	((= (L12_getstandard) 5) (setq statussta (nth 4 (L12_STANDARD_LIST))))
	)
statussta
)

(defun L12_standard_REVCL ( / )
	(Cond
	((= (L12_getstandard) 1) (mfixLayer "0400-SCOPE-co-50" "6" "continuous" "default" 1))
	((= (L12_getstandard) 2)	(mfixLayer "0400-SCOPE-co-50" "6" "continuous" "default" 1))
	((= (L12_getstandard) 3)	(mfixLayer "50C" "7" "continuous" 0.5 1))
	((= (L12_getstandard) 4) (mfixLayer "0400-SCOPE-co-50" "6" "continuous" "default" 1))
	((= (L12_getstandard) 5) (mfixLayer "0400-SCOPE-co-50" "6" "continuous" "default" 1))
	)
)

(defun L12_standard_maakview ( / )
	(Cond
	((= (L12_getstandard) 1)(mfixLayer "0000-VIEW-co-06"    "1"     "continuous" "default"   0     ))
	((= (L12_getstandard) 2)(mfixLayer "0000-VIEW-co-06"    "1"     "continuous" "default"   0     ))
	((= (L12_getstandard) 3)(mfixLayer "Vports" "1" "continuous" "default" 0))
	((= (L12_getstandard) 4)(mfixLayer "0000-VIEW-co-06"    "1"     "continuous" "default"   0     ))
	((= (L12_getstandard) 5)(mfixLayer "0000-VIEW-co-06"    "1"     "continuous" "default"   0     ))
	)
)

(defun L12_standard_aslijn (strLay ColName / )
	(Cond
		((= (L12_getstandard) 1) (mfixLayer strLay ColName "dashdot" "default"  1))
		((= (L12_getstandard) 2)	(mfixLayer strLay ColName "dashdot" "default"  1))
		((= (L12_getstandard) 3)	(mfixLayer "18D" "4" "dashdot" 0.18 1))
		((= (L12_getstandard) 4) (mfixLayer strLay ColName "dashdot" "default"  1))
		((= (L12_getstandard) 5) (mfixLayer strLay ColName "dashdot" "default"  1))
	)
)

(defun L12_standard_Breuklijn ()
	(Cond
		 ((= (L12_getstandard) 1) (mfixLayer "0000-ILLUSTRATIE-co-06" "1" "continuous" "default" 1))
		 ((= (L12_getstandard) 2) (mfixLayer "0000-ILLUSTRATIE-co-06" "1" "continuous" "default" 1))
		 ((= (L12_getstandard) 3) (mfixLayer "10C" "9" "continuous" 0.13 1))
		 ((= (L12_getstandard) 4) (mfixLayer "0000-ILLUSTRATIE-co-06" "1" "continuous" "default" 1))
		 ((= (L12_getstandard) 5) (mfixLayer "0000-ILLUSTRATIE-co-06" "1" "continuous" "default" 1))
	)
)

(defun L12_standard_zettekststyle ()
	(Cond
		((= (L12_getstandard) 1)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
		((= (L12_getstandard) 2)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
		((= (L12_getstandard) 3)(command "-style" "Arcelor" "isocpeur" "" "1" "" "" ""))
		((= (L12_getstandard) 4)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
		((= (L12_getstandard) 5)(command "-style" "Standard" "isocpeur" "" "1" "" "" ""))
	)
)
	
(defun L12_standard_zettekstlayer (layern tekst color / layern tekst color)	
	(Cond
		((= (L12_getstandard) 1)	(mfixlayer (strcat layern tekst) color "continuous" "default" 1))
		((= (L12_getstandard) 2)	(mfixlayer (strcat layern tekst) color "continuous" "default" 1))
		((= (L12_getstandard) 3)	(mfixlayer "Text" "7" "continuous" "default" 1))
		((= (L12_getstandard) 4)	(mfixlayer (strcat layern tekst) color "continuous" "default" 1))
		((= (L12_getstandard) 5)	(mfixlayer (strcat layern tekst) color "continuous" "default" 1))
	)
)









