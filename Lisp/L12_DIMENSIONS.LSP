;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_DIMENSIONS ()
(princ "L12_DIMENSIONS is loaded")
(princ)
)

;;-----[ Functie die de maatvoering instelt]------------------

(defun STIJLINVOER ( / tempo dimsize)
  (initerr)  (setvar "cmdecho" 0)
  (prompt "\nInstellen STIJL A, STIJL B en STIJL C:\n")
  (setq dimsize (L12_getdimsz))
  (setq tempo 1)
  (setq tempo (L12_stylesexist))
  (C:DimStijlB)
  (C:DimStijlC)
  (C:DimStijlA)
  (if (= tempo 1) 
  (progn
  (c:dimupd)
   (alert "STIJL A, STIJL B en\nSTIJL C zijn toegevoegd.")
  )
  )
  (reset)
  (princ)
)					;defun STIJLINVOER

(defun L12_setdim (stijl / L12_factor)
  (setq L12_factor (L12_getfactor)) 				;L12_SUPPORT.LSP
  (setvar "dimtih" 0)
  (setvar "dimtoh" 0)
  (setvar "dimsho" 1)
  (setvar "dimtvp" 1)
  (setvar "dimrnd" 0)
  (setvar "dimtfill" 1)
  (setvar "dimunit" 2)
  (setvar "dimdsep" ".")
  (setvar "dimexe" (/(* L12_factor dimsize)14.0))
  (setvar "dimexo" (/(* L12_factor dimsize)14.0))
  (setvar "dimtxt" (/(* L12_factor dimsize)10.0))
  (setvar "dimdli" (/(* L12_factor dimsize 2)10.0))
  (setvar "dimgap" L12_factor)
  (if (= stijl "STIJL A")
    (setvar "dimasz" (/(* L12_factor dimsize)35.0))
    (setvar "dimasz" (/(* L12_factor dimsize 3)35.0))
  )
  (if (= (L12_getmode) 3)
    (if	(= (tblsearch "DIMSTYLE" stijl) NIL)
      (command "_.DIMSTYLE" "AN" "Y" stijl "R" stijl)
      (command "_.DIMSTYLE" "AN" "Y" stijl "Y" "R" stijl)
    )
    (if	(= (tblsearch "DIMSTYLE" stijl) NIL)
      (command "dimstyle" "AN" "N" stijl "R" stijl)
      (command "dimstyle" "AN" "N" stijl "y" "R" stijl)
    )
  )
  (prompt "\n...\n")
  (redraw)
  (princ (strcat "\n" stijl " toegevoegd."))
  (princ)
)

(prompt
  "\n(STIJLINVOER) Functie die de maatvoering STIJL A, STIJL B en STIJL C instelt"
)
(defun C:DimStijlA (/ )
  (prompt "\nInstellen STIJL A: \n")
  (initerr)
  (setvar "cmdecho" 0)
  (GetBlockDef "MAATPUNT")
  (GetBlockDef "_DOT")
  (prompt "\nSTIJL A...\n")
  (L12_tekstmodus)
  (command "dimtxsty" "Standard")
  (L12_standard_DimStijl)
  (command "setvar" "dimblk" "MAATPUNT")
  (command "setvar" "dimldrblk" "_DOT")
  (command "dimse1" "on")
  (command "dimse2" "on")
  (setvar "dimlfac" (if (= (L12_getdimps) "1") (* 1 (L12_getschaal)) 1))
  (setvar "dimpost" "")
  (setvar "dimdec" 0)
  (setvar "dimzin" 8)
  (L12_setdim "STIJL A")
  (reset)
  (princ)
)


;;-----[ Functie die StijlB aanmaakt]-------------------------

(defun C:DimStijlB (/ cmd)
  (prompt "\nInstellen STIJL B:\n")
  (initerr) 
  (setvar "cmdecho" 0)
  (prompt "\nSTIJL B...\n")
  (L12_tekstmodus)
  (command "dimtxsty" "Standard")
  (L12_standard_DimStijl)
  (command "setvar" "dimblk" ".")
  (command "setvar" "dimldrblk" ".")
  (command "dimse1" "off")
  (command "dimse2" "off")
  (setvar "dimlfac" (if (= (L12_getdimps) "1") (* 1 (L12_getschaal)) 1))
  (setvar "dimpost" "")
  (setvar "dimdec" 0)
  (setvar "dimzin" 8)
  (L12_setdim "STIJL B")
  (reset)
  (princ)
)


;;-----[ Functie die StijlC aanmaakt]-------------------------

(defun C:DimStijlC (/ cmd)
  (prompt "\nInstellen STIJL C:\n")
  (initerr) 
  (setvar "cmdecho" 0)
  (GetBlockDef "_NONE")
  (prompt "\nSTIJL C...\n")
  (L12_tekstmodus)
  (command "dimtxsty" "Standard")
  (L12_standard_DimStijl)
  (command "setvar" "dimblk" "_NONE")
  (command "setvar" "dimldrblk" "_NONE")
  (command "dimse1" "off")
  (command "dimse2" "off")
  (setvar "dimlfac" (if (= (L12_getdimps) "1") (* 0.001 (L12_getschaal)) 0.001))
  (setvar "dimpost" "+<>")
  (setvar "dimdec" 3)
  (setvar "dimzin" 1)
  (L12_setdim "STIJL C")
  (reset)
  (princ)
)

(defun C:DimStijlOpm (/ cmd)
  (prompt "\nInstellen Stijl voor opmetingen:\n")
  ;;Instellen stijl B
  (prompt "\nSTIJL B...\n")
  (initerr)  (setvar "cmdecho" 0)
  (L12_tekstmodus)
  (command "dimtxsty" "Standard")
  (setvar "dimclrt" 7)
  (command "setvar" "dimblk" ".")
  (command "setvar" "dimldrblk" ".")
  (command "dimse1" "off")
  (command "dimse2" "off")
  (setvar "dimlfac" (if (= (L12_getdimps) "1") (* 1 (L12_getschaal)) 1))
  (setvar "dimpost" "")
  (setvar "dimdec" 0)
  (setvar "dimzin" 8)
  (L12_setdim "STIJL OPM")
  (reset)
  (princ)
)

;;-----[ Functies voor lineaire dimensies]--------------------
(prompt "\n(DIVERSE)     Functies die dim tekenen")

(defun L12_drawdim (stijl com / texteval c1 lp )
  (initerr)  
  (setvar "cmdecho" 0)
  (needupdate)
					;(L12_checkinstel)
  (cond
    ((= stijl "STIJL A")
     (if (= (tblsearch "DIMSTYLE" stijl) NIL)
       (progn(L12_checkinstel)(C:DimStijlA))
     )
    )
    ((= stijl "STIJL B")
     (if (= (tblsearch "DIMSTYLE" stijl) NIL)
       (progn(L12_checkinstel)(C:DimStijlB))
     )
    )
    ((= stijl "STIJL C")
     (if (= (tblsearch "DIMSTYLE" stijl) NIL)
       (progn(L12_checkinstel)(C:DimStijlC))
     )
    )
    ((= stijl "STIJL OPM")
     (if (= (tblsearch "DIMSTYLE" stijl) NIL)
       (C:DimStijlOpm)
     )
    )
  )
  (command "dimstyle" "R" stijl)
  (setq c1 (getvar "clayer"))
  (L12_standard_drawdim)
  (setq texteval (getvar "texteval"))
  (setvar "texteval" 1)
  (command com)
  (setq lp 1)
  (while lp
    (if	(> (getvar "cmdactive") 0)
      (command pause)
      (setq lp nil)
    )
  )
  (setvar "clayer" c1)
  (setvar "texteval" texteval)
  (reset)
  (princ)
)					; defun

(defun C:ccdimlinear (/)
  (L12_drawdim "STIJL A" "dimlinear")
)

(defun C:ccdimaligned (/)
  (L12_drawdim "STIJL A" "dimaligned")
)

(defun C:ccdimcontinue (/)
  (L12_drawdim "STIJL A" "dimcontinue")
)

(defun C:ccdimordinate (/)
  (L12_drawdim "STIJL C" "dimordinate")
)

(defun C:ccdimradius (/)
  (L12_drawdim "STIJL B" "dimradius")
)

(defun C:ccdimdiameter (/)
  (L12_drawdim "STIJL B" "dimdiameter")
)

(defun C:ccdimangular (/)
  (L12_drawdim "STIJL B" "dimangular")
)

;;-----[ Functies voor quickleader]----------------------------

(defun C:ccqleader (/)
  (L12_drawdim "STIJL A" "qleader")
)

(defun C:ccqleaderA (/)
  (L12_drawdim "STIJL A" "qleader")
)

(defun C:ccqleaderB (/)
  (L12_drawdim "STIJL B" "qleader")
)

(defun C:ccqleaderC (/)
  (L12_drawdim "STIJL C" "qleader")
)

;;-----[ Functie voor opmetingen]---------------------------

(defun C:CustAreaPer (/ acsp adoc cpt pntz inpt elist en ent fld lpt oid osm L12_factor )
  (initerr) 
  (setvar "cmdecho" 0)
  (setq L12_factor (L12_getschaal))
  (if (= (tblsearch "DIMSTYLE" "STIJL A") NIL)
    (C:DimStijlA)
  )
  (command "dimstyle" "R" "STIJL A")
  (or adoc
      (setq adoc
	     (vla-get-activedocument
	       (vlax-get-acad-object)
	     )
      )
  )
  (if
    (inPSPACE)
     (setq acsp (vla-get-paperspace adoc))
     (setq acsp (vla-get-modelspace adoc))
  )
  (setq osm (getvar "osmode"))
  (while
    (setq ent (entsel "\nSelect pline or hit Enter to exit"))
     (setq en (car ent))
	 (setq cpt  (osnap(cadr ent)"nea"))
	 (setq pntz (caddr cpt))
     (setvar "CLAYER" (cdr (assoc 8 (entget (car ent)))))
     (if (wcmatch (cdr (assoc 0 (setq elist (entget en))))
		  "*POLYLINE"
	 )
       (progn
	 (setq inpt (getpoint "\nPick the position of the textfield:"))
	 (setq inpt (list (car inpt) (cadr inpt) pntz))
	 (setq lpt (trans inpt 1 0 )
	 )

	 (if (= (Acad64Bit-version) T)	;Determines if AutoCAD is 64-Bit and adjusts the processing acordingly.
	   (progn
	     (setq
	       oID (vlax-invoke-method
		     (vla-get-Utility
		       (vla-get-ActiveDocument (vlax-get-acad-object))
		     )
		     'GetObjectIdString
		     (vlax-ename->vla-object en)
		     :vlax-False
		   )
	     )
	   )
	   (setq
	     oID (itoa (vla-get-objectid (vlax-ename->vla-object en)))
	   )
	 )
					;	  %<\AcObjProp.16.2 Object(%<\_ObjId 8796088207472>%).Area \f "%lu2%pr2%ps[, m²]%ds44%ct8[1e-006]">%
					;	  %<\AcObjProp.16.2 Object(%<\_ObjId 8796088211568>%).Length \f "%lu2%pr2%ps[, m]%ds44%ct8[0.001]">%

	 (setq fld
		(strcat
		  (strcat
		    "OPP.= "
		    "%<\\AcObjProp Object(%<\\_ObjId "
		    oID
		    ">%).Area \\f \"%lu2%pr2%ps[, m²]%ds44%ct8[1e-006]\">%"
		    "\\P"
		   )
		  (strcat
		    "OMTREK = "
		    "%<\\AcObjProp Object(%<\\_ObjId "
		    oID
		    ">%).Length \\f \"%lu2%pr2%ps[, m]%ds44%ct8[0.001]\">%"
		  )
		)
	 )
	 (setvar "cecolor" "7")
	 (setvar "osmode" 0)
	 (command
	   "_.mtext"
	   lpt
	   "_height"
	   (/(* L12_factor dimsize)10)
	   (strcat "@" (rtos (* L12_factor 50)) "," (rtos (/(* L12_factor dimsize)10)))
	   fld
	   ""
	 )
	 (setvar "cecolor" "bylayer")
	 (setvar "osmode" osm)
       )
     )
  )
  (reset)
  (princ)
)

(defun C:CustArea (/ acsp adoc cpt elist en ent fld lpt oid osm L12_factor pntz inpt)
  (initerr)  
  (setvar "cmdecho" 0)
  (setq L12_factor (L12_getschaal))
  (if (= (tblsearch "DIMSTYLE" "STIJL A") NIL)
    (C:DimStijlA)
  )
  (command "dimstyle" "R" "STIJL A")
  (or adoc
      (setq adoc
	     (vla-get-activedocument
	       (vlax-get-acad-object)
	     )
      )
  )
  (if (inPSPACE)
    (setq acsp (vla-get-paperspace adoc))
    (setq acsp (vla-get-modelspace adoc))
  )
  (setq osm (getvar "osmode"))


  (while
    (setq ent (entsel "\nSelect pline or hit Enter to exit"))
     (setq en (car ent))
	 (setq cpt  (osnap(cadr ent)"nea"))
	 (setq pntz (caddr cpt))
     (setvar "CLAYER" (cdr (assoc 8 (entget (car ent)))))
     (if (wcmatch (cdr (assoc 0 (setq elist (entget en))))
		  "*POLYLINE"
	 )
       (progn
	 (setq inpt (getpoint "\nPick the position of the textfield:"))
	 (setq inpt (list (car inpt) (cadr inpt) pntz))
	 (setq ;cpt (trans (cadr ent) 1 0)
	       lpt (trans inpt 1 0 )
	 )

	 (if (= (Acad64Bit-version) T)	;Determines if AutoCAD is 64-Bit and adjusts the processing acordingly.
	   (progn
	     (setq
	       oID (vlax-invoke-method
		     (vla-get-Utility
		       (vla-get-ActiveDocument (vlax-get-acad-object))
		     )
		     'GetObjectIdString
		     (vlax-ename->vla-object en)
		     :vlax-False
		   )
	     )
	   )
	   (setq
	     oID (itoa (vla-get-objectid (vlax-ename->vla-object en)))
	   )
	 )

	 (setq fld
		(strcat
		  (strcat
		    "OPP.= "
		    "%<\\AcObjProp Object(%<\\_ObjId "
		    oID
		    ">%).Area \\f \"%lu2%pr2%ps[, m²]%ds44%ct8[1e-006]\">%"
		  )
		)
	 )
	 (setvar "osmode" 0)
	 (setvar "cecolor" "7")
	 (command
	   "_.mtext"
	   lpt
	   "_height"
	   (/(* L12_factor dimsize)10)
	   (strcat "@" (rtos (* L12_factor 50)) "," (rtos (/(* L12_factor dimsize)10)))
	   fld
	   ""
	 )
	 (setvar "osmode" osm)
	 (setvar "cecolor" "bylayer")
       )
     )
  )
  (reset)
  (princ)
)

(defun C:CustPerim (/ acsp adoc cpt elist en ent fld lpt oid osm )
  (initerr)  (setvar "cmdecho" 0)
  (L12_checkinstel)
  (if (= (tblsearch "DIMSTYLE" "STIJL Opm") NIL)
    (C:DimStijlOpm)
  )
  (command "dimstyle" "R" "STIJL Opm")
  (or adoc
      (setq adoc
	     (vla-get-activedocument
	       (vlax-get-acad-object)
	     )
      )
  )
  (if (inPSPACE)
    (setq acsp (vla-get-paperspace adoc))
    (setq acsp (vla-get-modelspace adoc))
  )
  (setq osm (getvar "osmode"))
  (while
    (setq ent (entsel "\nSelect pline or hit Enter to exit"))
	 (setq cpt  (osnap(cadr ent)"nea"))
     (setq en (car ent))
     (setvar "CLAYER" (cdr (assoc 8 (entget (car ent)))))
     (if (wcmatch (cdr (assoc 0 (setq elist (entget en))))
		  "*POLYLINE"
	 )
       (progn
	 (setq ;cpt (trans (cadr ent) 1 0)
	       lpt (trans (getpoint cpt "\nPick the ending point of leader:")
			  1
			  0
		   )
	 )
	 (if (= (Acad64Bit-version) T)	;Determines if AutoCAD is 64-Bit and adjusts the processing acordingly.
	   (progn
	     (setq
	       oID (vlax-invoke-method
		     (vla-get-Utility
		       (vla-get-ActiveDocument (vlax-get-acad-object))
		     )
		     'GetObjectIdString
		     (vlax-ename->vla-object en)
		     :vlax-False
		   )
	     )
	   )
	   (setq
	     oID (itoa (vla-get-objectid (vlax-ename->vla-object en)))
	   )
	 )
	 (setq fld
		(strcat
		  (strcat
		    "LENGTE = "
		    "%<\\AcObjProp Object(%<\\_ObjId "
		    oID
		    ">%).Length \\f \"%lu2%pr2%ps[, m]%ds44%ct8[0.001]\">%"
		  )
		)
	 )
	 (setvar "osmode" 0)
	 (IF (NOT QLEADERLSP)
	   (LOAD "QLEADERLSP")
	 )
	 (ql-set '((64 . 1) (65 . 1) (67 . 2) (68 . 0)))
	 (command "qleader" cpt lpt fld "" "")
	 (setvar "osmode" osm)
       )
     )
  )
  (reset)
  (princ)
)

;;-----[ Functie voor aanmaken opmeting layers]--------------------

(defun opmlayer	(color fase / text)
  (L12_checkinstel)
  (setq text (strcase (getstring "Geef de naam van het materiaal")))
  (if (= fase "a")
    (mfixLayer (strcat "0000-AFBRAAK-" text) color "continuous" "default" 1 ) 
	(mfixLayer (strcat "0000-NIEUW-" text) color "continuous" "default" 1 )
  )
  (command "pline")
  (princ)
)					; defun


;;       Supporting Functions
;;-----[ 64Bit Version check]------------------------

(defun Acad64Bit-version ()
  (vl-load-com)
  (> (strlen (vl-prin1-to-string (vlax-get-acad-object))) 40)
)
					;End of Supporting Function - Acad64Bit-version
					
(defun L12_stylesexist ( / temp1)
(setq temp1 1)
(if (or (tblsearch "DIMSTYLE" "STIJL A")(tblsearch "DIMSTYLE" "STIJL B")(tblsearch "DIMSTYLE" "STIJL C"))
(progn; Initialize the dialog.
(setq Dcl_Id% (load_dialog "LAB2012.DCL"))
  (if (not (new_dialog "L12_StlExist" Dcl_Id%))
    (exit)
  )
  
(action_tile "Yes" "(setq temp1 1)(done_dialog)")
(action_tile "No" "(setq temp1 0)(done_dialog)")
  
(start_dialog)
(unload_dialog Dcl_Id%) 
)
);end if
temp1
)

(defun c:dimupd	(/ 
;*error* ocm lays 
ss c1 layern )

;  (defun *error* (msg)
;    (if	ocm
;      (setvar "cmdecho" 0)
;    )
;    (if	(not (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*"))
;      (princ (strcat "\n<< Error: " msg " >>"))
;    )
;	(reset)
;    (princ)
;  )

;  (setq	ocm  (getvar "CMDECHO")
;	lays (vla-get-layers
;	       (vla-get-ActiveDocument
;		 (vlax-get-acad-object)
;	       )
;	     )
;  )
;  (initerr)  
;  (setvar "cmdecho" 0)
  (setq c1 (getvar "clayer"))
  (L12_standard_drawdim)
  (setq layern (getvar "clayer"))
  
  (if (and (tblsearch "DIMSTYLE" "STIJL A")
	   (setq ss (ssget "_X" '((0 . "DIMENSION") (3 . "STIJL A"))))
      )
    (progn
      (command "-dimstyle" "_R" "STIJL A")
      (command "_.chprop" ss "" "_LA" layern "")
      (command "-dimstyle" "_A" ss "")
    )
    (princ
      "\n<< No Dimensions Found, or Dimstyle Doesn't Exist >>"
    )
  )
  (if (and (tblsearch "DIMSTYLE" "STIJL B")
	   (setq ss (ssget "_X" '((0 . "DIMENSION") (3 . "STIJL B"))))
      )
    (progn
      (command "-dimstyle" "_R" "STIJL B")
      (command "_.chprop" ss "" "_LA" layern "")
      (command "-dimstyle" "_A" ss "")
    )
    (princ
      "\n<< No Dimensions Found, or Dimstyle Doesn't Exist >>"
    )
  )
  (if (and (tblsearch "DIMSTYLE" "STIJL C")
	   (setq ss (ssget "_X" '((0 . "DIMENSION") (3 . "STIJL C"))))
      )
    (progn
      (command "-dimstyle" "_R" "STIJL C")
      (command "_.chprop" ss "" "_LA" layern "")
      (command "-dimstyle" "_A" ss "")
    )
    (princ
      "\n<< No Dimensions Found, or Dimstyle Doesn't Exist >>"
    )
  )
  (setvar "clayer" c1)
;  (reset)
  (princ)
)

