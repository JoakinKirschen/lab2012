;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_PLOT ()
(princ "L12_PLOT is loaded")
(princ)
)

;;-----[ Functie die plot volgens de vooringestelde waarden]--------------

(defun C:SplotA4 ( / PlName)
(setq PlName "A4")
(L12_SetPlot 0 PlName)
)

(defun C:SCplotA4 ( / PlName)
(setq PlName "A4")
(L12_SetPlot 1 PlName)
)

(defun C:SplotA3 ( / PlName)
(setq PlName "A3")
(L12_SetPlot 0 PlName)
)

(defun C:SCplotA3 ( / PlName)
(setq PlName "A3")
(L12_SetPlot 1 PlName)
)


(defun C:SplotA2 ( / PlName)
(setq PlName "A2")
(L12_SetPlot 0 PlName)
)

(defun C:SCplotA2 ( / PlName)
(setq PlName "A2")
(L12_SetPlot 1 PlName)
)


(defun C:SplotA1 ( / PlName)
(setq PlName "A1")
(L12_SetPlot 0 PlName)
)

(defun C:SCplotA1 ( / PlName)
(setq PlName "A1")
(L12_SetPlot 1 PlName)
)


(defun C:SplotA0 ( / PlName)
(setq PlName "A0")
(L12_SetPlot 0 PlName)
)

(defun C:SCplotA0 ( / PlName)
(setq PlName "A0")
(L12_SetPlot 1 PlName)
)

(defun C:Splot ( / PlName)
(initget 1 "A0 A0+ A1 A1+ A2 A2+ A3 A4")
(setq PlName (getkword "\nFormaat? A0+ / A0 / A1+ / A1 / A2 / A2+ / A3 / A4: "))
(L12_SetPlot 0 PlName)
)

(defun C:SCplot ( / PlName)
(initget 1 "A0 A0+ A1 A1+ A2 A2+ A3 A4")
(setq PlName (getkword "\nFormaat? A0+ / A0 / A1+ / A1 / A2 / A2+ / A3 / A4: "))
(L12_SetPlot 1 PlName)
)


(defun L12_SetPlot (color PlName /  ipt1 ipt2 width height orient Plname Pltemp plotter)
  (initerr)  (setvar "cmdecho" 0)
  (if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3"))
	  (progn
	  (if (= color 1)
		  (progn
		  (setq Pltemp (L12_standaard_getctbcol PlName))
		  (setq plotter "ArchiefColor.pc3")
		  )
		  (progn
		  (setq Pltemp (L12_standaard_getctb PlName))
		  (setq plotter "Archief.pc3")
		  )
		  )
	  )
	  (progn
	  (if (= color 1)
		  (progn
		  (setq Pltemp (L12_standaard_getctbcol PlName))
		  (setq plotter "COLORWAVE_KLEUR.pc3")
		  )
		  (progn
		  (setq Pltemp (L12_standaard_getctb PlName))
		  (setq plotter "COLORWAVE_ZW.pc3")
		  )
	  )
	  )
  )
  (setq ipt1 (getpoint "\nGeef beginpunt"))
  (setq ipt2 (getcorner ipt1 "\nGeef eindpunt"))
  (setq width  (abs(- (car ipt1)  (car ipt2))))
  (setq height (abs(- (cadr ipt1) (cadr ipt2))))
  (if (> width height)
  (setq orient "l")
  (setq orient "p")
  )
  
  (princ "\n")
  (if (not (inPSPACE))
    (Cond 
      ((or (= PlName "A4") (= PlName "a4")) (command "-plot" "y" "" plotter "A4" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" plotter "A3" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" plotter "Oce A2 420x594 mm (portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" plotter "420*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" plotter "Oce A1 594x841 mm (portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" plotter "594*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" plotter "A0 841x1189 mm" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" plotter "A0 841*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" "y" "n"))
    )    ;cond modelspace
    (Cond 
      ((or (= PlName "A4") (= PlName "a4")) (command "-plot" "y" "" plotter "A4" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" plotter "A3" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" plotter "A2 420x594 mm (portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" plotter "420*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" plotter "A1 594x841 mm (portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" plotter "594*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" plotter "A0 841x1189 mm" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" plotter "A0 841*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" "y" "n"))
    )    ;cond paperspace
  )    ;if
  (reset)
  (princ)
)

;;-----[ Functie die plot volgens de vooringestelde waarden]--------------

(defun C:PplotA4 ( / PlName)
(setq PlName "A4")
(L12_PowerPlot 0 PlName)
)

(defun C:PCplotA4 ( / PlName)
(setq PlName "A4")
(L12_PowerPlot 1 PlName)
)

(defun C:PplotA3 ( / PlName)
(setq PlName "A3")
(L12_PowerPlot 0 PlName)
)

(defun C:PCplotA3 ( / PlName)
(setq PlName "A3")
(L12_PowerPlot 1 PlName)
)


(defun C:PplotA2 ( / PlName)
(setq PlName "A2")
(L12_PowerPlot 0 PlName)
)

(defun C:PCplotA2 ( / PlName)
(setq PlName "A2")
(L12_PowerPlot 1 PlName)
)


(defun C:PplotA1 ( / PlName)
(setq PlName "A1")
(L12_PowerPlot 0 PlName)
)

(defun C:PCplotA1 ( / PlName)
(setq PlName "A1")
(L12_PowerPlot 1 PlName)
)


(defun C:PplotA0 ( / PlName)
(setq PlName "A0")
(L12_PowerPlot 0 PlName)
)

(defun C:PCplotA0 ( / PlName)
(setq PlName "A0")
(L12_PowerPlot 1 PlName)
)

(defun C:Pplot ( / PlName)
(initget 1 "A0 A0+ A1 A1+ A2 A2+ A3 A4")
(setq PlName (getkword "\nFormaat? A0+ / A0 / A1+ / A1 / A2 / A2+ / A3 / A4: "))
(L12_PowerPlot 0 PlName)
)

(defun C:PCplot ( / PlName)
(initget 1 "A0 A0+ A1 A1+ A2 A2+ A3 A4")
(setq PlName (getkword "\nFormaat? A0+ / A0 / A1+ / A1 / A2 / A2+ / A3 / A4: "))
(L12_PowerPlot 1 PlName)
)

(defun L12_PowerPlot (color PlName / ipt1 ipt2 PWrite Plname Pltemp width height orient plotter)
  (initerr) 
  (setvar "cmdecho" 0)
  (if (or (= PlName "A4") (= PlName "a4") (= PlName "A3") (= PlName "a3"))
	  (progn
	  (if (= color 1)
		  (progn
		  (setq Pltemp (L12_standaard_getctbcol PlName))
		  (setq plotter "ArchiefColor.pc3")
		  )
		  (progn
		  (setq Pltemp (L12_standaard_getctb PlName))
		  (setq plotter "Archief.pc3")
		  )
		  )
	  )
	  (progn
	  (if (= color 1)
		  (progn
		  (setq Pltemp (L12_standaard_getctbcol PlName))
		  (setq plotter "COLORWAVE_KLEUR.pc3")
		  )
		  (progn
		  (setq Pltemp (L12_standaard_getctb PlName))
		  (setq plotter "COLORWAVE_ZW.pc3")
		  )
	  )
	  )
  )
  (setq ipt1 (getpoint "\nGeef beginpunt"))
  (setq ipt2 (getcorner ipt1 "\nGeef eindpunt"))
  (setq width  (abs(- (car ipt1)  (car ipt2))))
  (setq height (abs(- (cadr ipt1) (cadr ipt2))))
  (if (> width height)
  (setq orient "l")
  (setq orient "p")
  )
  (initget "Yes No")
  (setq PWrite (getkword "\nInstellingen op huidige layout toepassen? Yes / No: "))
  (if (= PWrite nil) (setq PWrite "n")())
  (princ "\n")
  (if (not (inPSPACE))
    (Cond 
      ((or (= PlName "A4") (= PlName "a3")) (command "-plot" "y" "" plotter "A4" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" plotter "A3" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" plotter "A2 (420x594 mm)(portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" plotter "420*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" plotter "A1 (594x841 mm)(portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" plotter "594*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" plotter "A0 (841x1189 mm)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" plotter "841*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
    )    ;cond modelspace
    (Cond 
      ((or (= PlName "A4") (= PlName "a4")) (command "-plot" "y" "" plotter "A4" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" plotter "A3" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" plotter "A2 (420x594 mm)(portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" plotter "420*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" plotter "A1 (594x841 mm)(Portrait)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" plotter "594*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" plotter "A0 (841x1189 mm)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" plotter "841*2100" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
    )    ;cond paperspace
  )    ;if
  (reset)
  (princ)
)

;;-----[ Functie die plot volgens de vooringestelde waarden]--------------

(defun C:BPlot ( / ipt1 ipt2 PWrite Plname Pltemp)
  (initerr)  (setvar "cmdecho" 0)
  (setq Pltemp (L12_standaard_getctb "A3"))
  (setq ipt1 (getpoint "\nGeef beginpunt"))
  (setq ipt2 (getcorner ipt1 "\nGeef eindpunt"))
  (setq width  (abs(- (car ipt1)  (car ipt2))))
  (setq height (abs(- (cadr ipt1) (cadr ipt2))))
  (if (> width height)
  (setq orient "l")
  (setq orient "p")
  )
  (initget "Yes No")
  (setq PWrite (getkword "\nInstellingen op huidige layout toepassen? Yes / No: "))
  (if (= PWrite nil) (setq PWrite "n")())
  (princ "\n")
  (if (not (inPSPACE))
    (command "-plot" "y" "" "Bibliotheek.pc3" "A3" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y");cond modelspace
    (command "-plot" "y" "" "Bibliotheek.pc3" "A3" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y");cond paperspace
  )
  (reset)
  (princ)
)


(defun C:FplotA4 ( / PlName)
(setq PlName "A4")
(L12_FilePlot 0 PlName)
)

(defun C:FCplotA4 ( / PlName)
(setq PlName "A4")
(L12_FilePlot 1 PlName)
)

(defun C:FplotA3 ( / PlName)
(setq PlName "A3")
(L12_FilePlot 0 PlName)
)

(defun C:FCplotA3 ( / PlName)
(setq PlName "A3")
(L12_FilePlot 1 PlName)
)


(defun C:FplotA2 ( / PlName)
(setq PlName "A2")
(L12_FilePlot 0 PlName)
)

(defun C:FCplotA2 ( / PlName)
(setq PlName "A2")
(L12_FilePlot 1 PlName)
)


(defun C:FplotA1 ( / PlName)
(setq PlName "A1")
(L12_FilePlot 0 PlName)
)

(defun C:FCplotA1 ( / PlName)
(setq PlName "A1")
(L12_FilePlot 1 PlName)
)


(defun C:FplotA0 ( / PlName)
(setq PlName "A0")
(L12_FilePlot 0 PlName)
)

(defun C:FCplotA0 ( / PlName)
(setq PlName "A0")
(L12_FilePlot 1 PlName)
)

(defun C:Fplot ( / PlName)
(initget 1 "A0 A0+ A1 A1+ A2 A2+ A3 A4")
(setq PlName (getkword "\nFormaat? A0+ / A0 / A1+ / A1 / A2 / A2+ / A3 / A4: "))
(L12_FilePlot 0 PlName)
)

(defun C:FCplot ( / PlName)
(initget 1 "A0 A0+ A1 A1+ A2 A2+ A3 A4")
(setq PlName (getkword "\nFormaat? A0+ / A0 / A1+ / A1 / A2 / A2+ / A3 / A4: "))
(L12_FilePlot 1 PlName)
)


;;-----[ Functie die plot naar file volgens de vooringestelde waarden]--------------

(defun L12_FilePlot (color Plname / ipt1 ipt2 PWrite Plname PSize PFile Pltemp version width height orient color)
  (initerr)  (setvar "cmdecho" 0)
  (setq version (L12_getAcadVers))
  
  (if (= color 1)
  (setq Pltemp (L12_standaard_getctbcol PlName))
  (setq Pltemp (L12_standaard_getctb PlName))
  )
  
  
  (if (or (= PlName "A1+") (= PlName "a1+"))
    (progn
        (initget 1 "945 1050 1155 1260 1470 1680 1890 2000")
  	(setq PSize (getkword "\nGewenste breedte? \n945 - 1050 - 1155 - 1260 - 1470 - 1680 - 1890 - 2000: "))
    )
  )
  (if (or (= PlName "A0+") (= PlName "a0+"))
    (progn
        (initget 1 "1300 1400 1500 1600 1700 1800 1900 2000 2100 2200")
  	(setq PSize (getkword "\nGewenste breedte? \n1300 - 1400 - 1500 - 1600 - 1700 - 1800 - 1900 - 2000 - 2100 - 2200: "))
    )
  )
  (if (or (= PlName "A2+") (= PlName "a2+"))
    (progn
        (initget 1 "650 700 750 800 850 900 950 1000 1100 1200 1300 1400 1500")
  	(setq PSize (getkword "\nGewenste breedte? \n650 - 700 - 750 - 800 - 850 - 900 - 950 - 1000 - 1200 - 1300 - 1400 - 1500: "))
    )
  )
    
  (setq ipt1 (getpoint "\nGeef beginpunt"))
  (setq ipt2 (getcorner ipt1 "\nGeef eindpunt"))
  (setq width  (abs(- (car ipt1)  (car ipt2))))
  (setq height (abs(- (cadr ipt1) (cadr ipt2))))
  (if (> width height)
  (setq orient "l")
  (setq orient "p")
  )
  
  (initget "Yes No")
  (setq PWrite (getkword "\nInstellingen op huidige layout toepassen? Yes / No: "))
  (if (= PWrite nil) (setq PWrite "n")())
  (princ "\n")
  
(if (< version 18.0)
  (progn   
  
  (if (not (inPSPACE))
    (Cond
      ((or (= PlName "A4") (= PlName "a4")) (command "-plot" "y" "" "PDF Printer.pc3" "A4[210mm x 297mm]" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n"  PWrite "y"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A3 297x420" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n"  PWrite "y"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A2 420x594" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A1 594x840" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A0 840x1188" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" "PDF Printer.pc3" (strcat "CAD_A1 594x" PSize) "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" "PDF Printer.pc3" (strcat "CAD_A2 420x" PSize) "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" "PDF Printer.pc3" (strcat "CAD_A0 840x" PSize) "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" "n" PWrite "y"))
    )     ;cond modelspace
    (Cond
      ((or (= PlName "A4") (= PlName "a4")) (command "-plot" "y" "" "PDF Printer.pc3" "A4[210mm x 297mm]" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A3 297x420" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A2 420x594" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A1 594x840" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" "PDF Printer.pc3" "CAD_A0 840x1188" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" "PDF Printer.pc3" (strcat "CAD_A1 594x" PSize) "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" "PDF Printer.pc3" (strcat "CAD_A2 420x" PSize) "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" "PDF Printer.pc3" (strcat "CAD_A0 840x" PSize) "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" "n" PWrite "y"))
    )     ;cond paperspace
  )       ;if
  )
  (progn   
  (setq PFile (getfiled "Save As" "" "pdf" 1))
  (if (not (inPSPACE))
    (Cond
      ((or (= PlName "A4") (= PlName "a4")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A4 (210.00 x 297.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile PWrite "y"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A3 (420.00 x 297.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile  PWrite "y"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A2 (594.00 x 420.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile PWrite "y"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A1 (841.00 x 594.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile PWrite "y"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A0 (1189.00 x 841.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile PWrite "y"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" (strcat "A1+ (" PSize " x 594)") "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile PWrite "y"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" (strcat "A2+ (" PSize " x 420)") "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile PWrite "y"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" (strcat "A0+ (" PSize " x 841)") "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "a" PFile PWrite "y"))
    )     ;cond modelspace
    (Cond
      ((or (= PlName "A4") (= PlName "a4")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A4 (210.00 x 296.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
      ((or (= PlName "A3") (= PlName "a3")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A3 (420.00 x 297.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
      ((or (= PlName "A2") (= PlName "a2")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A2 (594.00 x 420.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
      ((or (= PlName "A1") (= PlName "a1")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A1 (841.00 x 594.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
      ((or (= PlName "A0") (= PlName "a0")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" "ISO A0 (1189.00 x 841.00 MM)" "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
      ((or (= PlName "A1+") (= PlName "a1+")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" (strcat "A1+ (" PSize " x 594)") "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
      ((or (= PlName "A2+") (= PlName "a2+")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" (strcat "A2+ (" PSize " x 420)") "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
      ((or (= PlName "A0+") (= PlName "a0+")) (command "-plot" "y" "" "L12 DWG To PDF.pc3" (strcat "A0+ (" PSize " x 841)") "m" orient "n" "w" ipt1 ipt2 "f" "c" "y" Pltemp "y" "n" "n" "n" PFile PWrite "y"))
    )     ;cond paperspace
  )       ;if
  )
  )
  (reset)
  (princ)
)