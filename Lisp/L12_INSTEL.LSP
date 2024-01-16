;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_INSTEL ()
(princ "L12_INSTEL is loaded")
(princ)
)

;;-----[ Functie die de tekenparameters instelt ]-------------

(prompt
  "\n(INSTEL)	  Functie die de tekenparameters instelt volgens de schaal"
)

;Standaardwaarden voor instel
(defun getdefault (val / )
  (cond 
    ((= val "taal") 1)
    ((= val "standard") 1)
	((= val "dimsz") "30")
	((= val "dimps") "0")
	((= val "scale") 50)
  )
)

;Subfunktie voor instel
(defun check (var / )
  (if (= var 10)
	(mode_tile "CustSch" 0)
	(mode_tile "CustSch" 1)
  )					;end if
)


;grey out voor schaal indien in paperspace
(defun L12_scalecheck (lijst3 curmode schaal /)
  (if (and (inPspace)(= curmode 3))
	(progn
	  (mode_tile "CustSch" 1)
	  (mode_tile "Schalen" 1)
	  (set_tile_list "Schalen" lijst3 "1:1")
	)
	(progn
	  (mode_tile "CustSch" 0)
	  (mode_tile "Schalen" 0)
	  (if (or (= schaal 1.0)(= schaal 2.0)(= schaal 5.0)(= schaal 10.0)(= schaal 20.0)
		  (= schaal 50.0)(= schaal 100.0)(= schaal 200.0)(= schaal 500.0)(= schaal 1000.0)
		  )
		(progn
		 (set_tile_list "Schalen" lijst3 (strcat "1:" (rtos schaal 2 0)))
		 (mode_tile "CustSch" 1)
		 )
		(progn
		 (set_tile_list "Schalen" lijst3 (strcat "Custom"))
		 (mode_tile "CustSch" 0)
		)
	  )					;end if
	)
  )
)

(defun L12_dimps (dimps / dimps)
	(if (= dimps "1")
	  (progn
	  (mode_tile "Modus" 1)
	  (set_tile "Modus" "2")
	  (mode_tile "Schalen" 0)
	  )
	  (progn
	  (mode_tile "Modus" 0)
	  )
	)
)

(defun INSTEL (/ scale taal standard temp temp1 temp2 temp3 temp4 temp5 temp6 dimsz dimps lijntypes Dcl_Id%  lijst1  lijst2 lijst3 lijst4)
  (needupdate)
  (initerr)
  (setvar "cmdecho" 1)
  ; Lijsten
  (setq lijst1 (list "Dutch" "French" "English"))
  (setq lijst2 (list 1.0 2.0 5.0 10.0 20.0 50.0	100.0 200.0 500.0 1000.0 ""))
  (setq lijst3 (list "1:1" "1:2" "1:5" "1:10" "1:20" "1:50" "1:100" "1:200" "1:500"	"1:1000" "Custom" ))
  (setq lijst4 (L12_standard_list));talen standaard
  
  ; Initialize the dialog.
  (setq Dcl_Id% (load_dialog "LAB2012.DCL"))
  (if (not (new_dialog "L2012_Instel" Dcl_Id%))
	(exit)
  )
  ; Preset talen in dialog box
  
  (if (L12_mark)
	(progn
	(setq taal (L12_getlang))
	(setq standard (L12_getstandard))
	(setq dimsz (itoa(L12_getdimsz)))
	(setq dimps (L12_getdimps))
	(if (= standard 0) (setq standard 1))
	(if (= (L12_getschaal) "Annotative")(setq scale (getdefault "scale"))(setq scale (L12_getschaal)))
	)
	(progn
	(setq taal (getdefault "taal"))
	(setq standard (getdefault "standard"))
	(setq dimsz (getdefault "dimsz"))
	(setq dimps (getdefault "dimps"))
	(setq scale (getdefault "scale"))
	)
  )
  (set_tile_list "Talen" lijst1 (nth (- taal 1) lijst1))
  (set_tile_list "Standard" lijst4 (nth (- standard 1) lijst4))
  
  ; Preset maten in dialog box
  (setq temp2 "ja_r")

  ; Preset Modus
  (if (= (getvar "useri1") 0)
	(progn
		(if (getenv "L12_Modus")
		(setq temp3 (getenv "L12_Modus"))
		(setq temp3 "3")
		)
	)
	(setq temp3 "2")
  )
  
  ; Preset schalen in dialog box
  (start_list "Schalen")
  (mapcar 'add_list lijst3)
  (end_list)
  
  (L12_scalecheck lijst3 (atoi temp3) scale)
  (L12_dimps dimps)
  
  ; Preset Layer Creation 
  (setq temp4 "0")
  (setq temp5 "0")
  (set_tile "Maten" temp2)
  (set_tile "Modus" temp3)
  (set_tile "Toggle2D" temp4)
  (set_tile "Toggle3D" temp5)
  (set_tile "dim_sz" dimsz)
  (set_tile "dim_ps" dimps)
  
  
  ; Action buttons
  (action_tile "Talen" "(setq taal (+ (atoi $value) 1))")
  (action_tile "Standard" "(setq standard (+ (atoi $value) 1))")
  (action_tile
	"Schalen"
	"(setq temp (atoi $value))(check temp)(setq scale (nth (atoi $value) lijst2))"
  )
  (action_tile
	"CustSch"
	"(check_editint \"scale\")(setq scale (atoi scale))"
  )
  (action_tile "accept" "(setq temp1 1)(done_dialog)")
  (action_tile "cancel" "(setq temp1 0)(done_dialog)(exit)")
  (action_tile "Maten" "(setq temp2 $value)")
  (action_tile "Modus" "(setq temp3 $value)(L12_scalecheck lijst3 (atoi $value) scale)(setenv \"L12_Modus\" $value)")
  (action_tile "Toggle2D" "(setq temp4 $value)")
  (action_tile "Toggle3D" "(setq temp5 $value)")
					;(action_tile "Settings" "(setq temp6 1)(done_dialog)")
					;(action_tile "Info" "(infobox taal)")
					; Unload Dialog
  (action_tile "dim_sz" "(setq dimsz $value)")
  (action_tile "dim_ps" "(setq dimps $value)(L12_dimps dimps)(setq temp3 \"2\")(setenv \"L12_Modus\" \"2\")")
  (start_dialog)
  (unload_dialog Dcl_Id%)
					;Running Commands
  (if (= temp1 1)
	(progn
	  (if (or(= temp3 "3")(= dimps "1"))
		(progn
			(setvar "ltscale" 0.5)
					;		(command ".-style" "Lab2012"  "isocpeur.ttf" "a" "y" "n" "0.0" "1" "0.0" "No" "No")
		)
		(progn
			(setvar "ltscale" (/ scale 2))
					;		(command ".-style" "Standard" "isocpeur" "" "1" "" "" "")
		)
	  )
	  (L12_setuserr L12_GMI_stamp (atoi temp3) L12_Lab_version taal standard scale dimsz dimps)
	  (L12_setschaal (fix scale))
	  ;(L12_setdimsc (fix temp7))
	  (if (= temp4 "1")
	  (if (not L12_GMI2DLAYER)
	  (progn (load "L12_GMI2DLAYER.LSP") (C:L12_GMI2DLAYER))
	  )
	  )
	  (if (= temp5 "1")
	  (if (not L12_GMI3DLAYER)
	  (progn (load "L12_GMI3DLAYER.LSP") (C:L12_GMI3DLAYER))
	  )
	  )
	  (C:Loadlinetypes)
	  (setvar "celtscale" 1)
	  (setvar "psltscale" 0)
	  (setvar "dimassoc" 2)
	  (setvar "coords" 2)
	  (setvar "insbase" '(0 0 0))
	  (setvar "ANGBASE" 0)
	  (setvar "ANGDIR" 0)
	  (setvar "AUNITS" 0)
	  (setvar "AUPREC" 2)
	  (setvar "INSUNITS" 4)
	  (setvar "LUNITS" 2)
	  (setvar "LUPREC" 2)
	  (setvar "donutid" 0.00)
	  (setvar "donutod" 50.0)
	  (setvar "elevation" 0.00)
	  (setvar "proxygraphics" 1)
	  (setvar "proxynotice" 0)
	  (setvar "proxyshow" 1)
	  (setvar "insunits" 4)
	  (setvar "coords" 2)
	  (setvar "blipmode" 0)
	  (setvar "pickstyle" 1)
	  (setvar "textfill" 1)
	  (setvar "mirrtext" 0)
	  (setvar "attdia" 1)
	  (setvar "attmode" 1)
	  (setvar "ucsicon" 0)
	  (setvar "filedia" 1)
	  (setvar "measurement" 1)
	  (setvar "skpoly" 1)
	  (setvar "msltscale" 1)
	  (setvar "psltscale" 1)
	  (setvar "useri2" 0)
	  (setvar "REGENMODE" 1)
	  (command "viewres" "y" "2000")
	  (L12_standard_instel)
	  (redraw)
	  (L12_Statusb)
	  (if (= temp2 "ja_r")
	  (STIJLINVOER)
	  )
	)
  )
  (reset)
  (princ)
)

(defun infobox (lang / )
  (alert
	"Beste AutoCAD gebruiker,
 	 \nWe zijn trots om u Lab2012 te presenteren. 
 	 \nLab2012 werd onder ontwikkeld door Joakin Kirschen de verstotene.
 	 "
  )
  (princ)
)


;;-----[ Functie die lijntypes laad]--------------------------

(defun C:Loadlinetypes (/ li )
  (initerr)
  (setvar "cmdecho" 0)
  (setq li (list "BORDER" "BORDER2" "CENTER" "CENTER2" "DASHDOT" "DASHDOT2" "DIVIDE" "DIVIDE2" "HIDDEN" "HIDDEN2" "PHANTOM" "PHANTOM2"))
  (foreach n li
	(If (= (TBLSEARCH "LTYPE" n) nil)
		(command "-linetype" "l" n "LABlines.lin" "")
		(command "-linetype" "l" n "LABlines.lin" "y" "")
	)
  )
  (reset)
  (princ)
)

(prompt
  "\n(MLAYER)	  Functie die layers aanmaakt volgens actuele instellingen"
)
(defun mLayer (baseLayName / layName discipline cCode lCode )
  (initerr)  
  (setvar "cmdecho" 0)
  (Cond	
	((OR (= ccCurLType "")
		 (= ccCurLType nil)
		 (= ccCurLType "CONTINUOUS")
	 )
	 (setq lCode "-co")
	)
	((= ccCurLType "HIDDEN")(setq lCode "-hi"))
	((= ccCurLType "HIDDEN2")(setq lCode "-hi2"))
	((= ccCurLType "DASHDOT")(setq lCode "-dd"))
	((= ccCurLType "DASHDOT2")(setq lCode "-dd2"))
	((= ccCurLType "DIVIDE")(setq lCode "-di"))
	((= ccCurLType "DIVIDE2")(setq lCode "-di2"))
	((= ccCurLType "PHANTOM")(setq lCode "-ph"))
	((= ccCurLType "PHANTOM2")(setq lCode "-ph2"))
	((= ccCurLType "DASHED")(setq lCode "-da"))
	((= ccCurLType "DASHED2")(setq lCode "-da2"))
	((= ccCurLType "BORDER")(setq lCode "-bo"))
	((= ccCurLType "BORDER2")(setq lCode "-bo2"))
	((= ccCurLType "CENTER")(setq lCode "-ce"))
	((= ccCurLType "CENTER2")(setq lCode "-ce2"))
	((not nil) (setq lCode (strcat "-" (substr ccCurLType 1 2))))
  )
  (Cond	
	((= ccCurColor "1") (setq cCode "-06"))
	((= ccCurColor "3") (setq cCode "-12"))
	((= ccCurColor "7") (setq cCode "-25"))
	((= ccCurColor "2") (setq cCode "-35"))
	((= ccCurColor "6") (setq cCode "-50"))
	((= ccCurColor "4") (setq cCode "-70"))
	((= ccCurColor "5") (setq cCode "-90"))
	((= ccCurColor "8") (setq cCode "-GR"))
	(nil (setq cCode "-25"))
	((not nil) (setq cCode "-25"))
  )
  (setq discipline (getenv "L12_Disipline"))
  (setq layName (strcat discipline baseLayName lCode cCode))
	(If (= (TBLSEARCH "LTYPE" ccCurLType) nil)
		(command "-linetype" "l" ccCurLType "LABlines.lin" "")
	)
   ;; Aanmaken layer indien hij nog niet bestaat
  (if (= (tblSearch "LAYER" layName) nil)
  (entmake (list (cons 0 "LAYER")
				 (cons 100 "AcDbSymbolTableRecord")
				 (cons 100 "AcDbLayerTableRecord")
				 (cons 290 1)
				 (cons 2 layName)
				 (cons 6 ccCurLType)
				 (cons 70 0)
				 (cons 62 (atoi ccCurColor))
			)
  )
  (command "-layer" "on" layName "")
  )
  (reset)
  (setvar "CLAYER" layName)
  (princ)
)					;defun mlayer


(defun mfixLayer (baseLayName color linetype lineweight plot / layName discipline)
(initerr)  
(setvar "cmdecho" 0)
(if (= lineweight "default")
	(setq lineweight (- 0 3))
	(setq lineweight (fix(* lineweight 100)))
)
(setq discipline (L12_standard_mfixLayer))
  
(setq layName (strcat discipline baseLayName))
(if (= (tblSearch "LAYER" layName) nil)
  ;(Command "._layer" "M" layName "P" plot "" "c" color "" "LT" linetype "" "")
  (progn
  (If (= (TBLSEARCH "LTYPE" linetype) nil)
		(command "-linetype" "l" linetype "LABlines.lin" "")
  )
  (entmake (list (cons 0 "LAYER")
				 (cons 100 "AcDbSymbolTableRecord")
				 (cons 100 "AcDbLayerTableRecord")
				 (cons 290 plot)
				 (cons 370 lineweight)
				 (cons 2 layName)
				 (cons 6 linetype)
				 (cons 70 0)
				 (cons 62 (atoi color))
			)
  )
  )
  (command "-layer" "on" layName "")
)
(reset)
(setvar "CLAYER" layName)
(princ)
)


;;-----[ Functie die de huidige mode instelt]-----------------

(prompt
  "\n(SETCMDMODE)  Functie die de huidige mode instelt"
)
(defun setCmdMode (cmdName /)
  (setq ccCurCommand cmdName)
  (if (= ccCurCommand "0")
	(setq Commandflag nil)
	(setq Commandflag 1)
  )
  (princ)
)					;defun setCmdMode


;;-----[ Functie die de huidige kleur instelt]----------------

(prompt
  "\n(SETCOLMODE)  Functie die de huidige kleur instelt"
)
(defun setColMode (colName /)
  (needupdate)
  (setq ccCurColor colName)
  (L12_statusb)
  (princ)
)					;defun setColMode


;;-----[ Functie die het huidige lijntype instelt]------------

(prompt
  "\n(SETLTPMODE)  Functie die het huidige lijntype instelt"
)
(defun setLtpMode (ltpName /)
  (needupdate)
  (setq ccCurLType ltpName)
  (L12_statusb)
  (princ)
)					;defun setLtpMode


;;-----[ Functie die het huidig commando uitvoert]------------

(prompt
  "\n(RUNCOMMAND)  Functie die het huidig commando uitvoert"
)
(defun c:runCommand (/)
  (progn
	(princ ccCurCommand)
	(command "pline")
	(L12_statusb)
  )					;prong
  (princ)
)					;defun runcommand

