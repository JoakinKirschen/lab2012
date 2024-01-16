;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_support ()
(princ "L12_support is loaded")
(princ)
)

;;-----[ Functie die info over Lab2012 geeft]----------------

(defun L12_getAcadVers ( / version)
(setq version (atof (getvar 'AcadVer)))
version
)

(defun C:L12_AUTOSAVE ( / )
(startapp "explorer" (strcat "/n,/e," (getvar "SAVEFILEPATH"))) 
(princ)
)

(defun AboutLab2012 ( / )
  (princ "\n")
  (princ "\n[================================================================]")
  (princ "\n[=========================== LAB_2012 ===========================]")
  (princ "\n[================================================================]")
  (princ (strcat "\n[====================  LAB_2012, versie " (rtos L12_Lab_version 2 2) " =================]"))
  (princ "\n[================================================================]")
  (princ "\n[========================= CAD-WERKGROEP ========================]")
  (princ "\n[================================================================]")
  (princ "\n[=========================== PEJA ===============================]")
  (princ "\n[================================================================]")
  (princ "\n[=========================== JOKI ===============================]")
  (princ "\n[================================================================]")
  (princ "\n")
  (princ)
)

(defun c:GetData ( / )
(entget (car (entsel)) '("ACAD")) 
)

;; Function to obtain list of scale entity names
(defun GetScaleListEntities (/ lst item)
  (setq lst nil)
  (foreach item (dictsearch (namedobjdict) "ACAD_SCALELIST")
    (if    (= 350 (car item))
      (setq lst (cons (cdr item) lst))
    ) ;_ end of if
  ) ;_ end of foreach
  lst
) ;_ end of defun

(defun _SortedScaleList (lst)
  ;; Alan J. Thompson, 11.24.10
  (if lst
    (vl-sort
      (mapcar (function (lambda (x) (cdr (assoc 300 (entget x))))) lst)
      (function (lambda (a b / f)
                  (defun f (s / m l)
                    (if (setq m (cdr (cond ((member 61 (setq l (vl-remove 32 (vl-string->list s)))))
                                           ((member 58 l))
                                     )
                                )
                        )
                      (atof (vl-list->string m))
                      (atof s)
                    )
                  )
                  (< (f a) (f b))
                )
      )
    )
  )
)

(defun L12_checkinstel ( / )
(if (not(L12_mark))
		(INSTEL)
)
(princ )
)

(defun L12_loaddwg (FileName ReadOnly / )
(vla-activate (vla-Open
 (vla-get-Documents
  (vlax-get-Acad-Object)
 )
 (findfile (strcat FileName ".dwg"))
 (if ReadOnly
  :vlax-true
  :vlax-false
 )
))
)

;set drawing related variables 
;mark/version/mode/lang/open slots
;xxxx/xxxxxx/x/x/xxx

(defun L12_setuserr (mark mode version language standard scale dimsz dimps / standard mark mode version language scale dimsz dimps)
;(setvar "userr2" (fix(+ (* mark 100000000000)(* version 10000000)(* mode 10000)(* language 1000)(* standard 100))))
(L12_dwgprops-set-custom-prop "L12_mark" mark nil)
(L12_dwgprops-set-custom-prop "L12_mode" (rtos mode) nil)
(L12_dwgprops-set-custom-prop "L12_version" (rtos version) nil)
(L12_dwgprops-set-custom-prop "L12_language" (rtos language) nil)
(L12_dwgprops-set-custom-prop "L12_standard" (rtos standard) nil)
(L12_dwgprops-set-custom-prop "L12_scale" (rtos scale) nil)
(L12_dwgprops-set-custom-prop "L12_dimsz" dimsz nil)
(L12_dwgprops-set-custom-prop "L12_dimps" dimps nil)
)

(defun L12_mark ()
	(and (eq (L12_dwgprops-get-custom-prop "L12_mark" nil) "7139"))
)

(defun L12_getmode ( / L12_mode )
(if (L12_dwgprops-get-custom-prop "L12_mode" nil)
	(setq L12_mode  (atoi (L12_dwgprops-get-custom-prop "L12_mode" nil)))
	(setq L12_mode nil)
)
L12_mode
)

(defun L12_getver ( / L12_ver)
(if (L12_dwgprops-get-custom-prop "L12_version" nil)
	(setq L12_ver  (atof (L12_dwgprops-get-custom-prop "L12_version" nil)))
	(setq L12_ver nil)
)
L12_ver
)

(defun L12_getlang ( / L12_lang)
(if (L12_dwgprops-get-custom-prop "L12_language" nil)
	(setq L12_lang  (atoi (L12_dwgprops-get-custom-prop "L12_language" nil)))
	(setq L12_lang (getdefault "taal")) 					;L12_INSTEL.lsp
)
L12_lang
)

(defun L12_getstandard ( / L12_stand)
(if (L12_dwgprops-get-custom-prop "L12_standard" nil)
	(setq L12_stand  (atoi (L12_dwgprops-get-custom-prop "L12_standard" nil)))
	(setq L12_stand (getdefault "standard")) 				;L12_INSTEL.lsp
)
L12_stand
)

(defun L12_getschaal ( / schaal)
(L12_checkinstel)
(if (= (L12_getmode) 2)
    (progn
		(if (and (L12_mark) (/=  (getvar "useri1") 0))
		(setq schaal (getvar "useri1"))
		(setq schaal (atof (L12_dwgprops-get-custom-prop "L12_scale" nil)))
		)
	)
	(progn
		(setq schaal (/ 1 (getvar "cannoscalevalue")))
	)
)
schaal
)

(defun L12_getdimsz ( / L12_dimsz)
(if (L12_dwgprops-get-custom-prop "L12_dimsz" nil)
	(setq L12_dimsz  (atoi (L12_dwgprops-get-custom-prop "L12_dimsz" nil)))
	(setq L12_dimsz  (atoi (getdefault "dimsz"))) 				;L12_INSTEL.lsp
)
L12_dimsz
)

(defun L12_getdimps ( / L12_dimps)
(if (L12_dwgprops-get-custom-prop "L12_dimps" nil)
	(setq L12_dimps (L12_dwgprops-get-custom-prop "L12_dimps" nil))
	(setq L12_dimps (getdefault "dimps")) 				;L12_INSTEL.lsp
)
L12_dimps
)

(defun L12_getfactor ( / L12_factor schaal)
    (L12_checkinstel)
	(if (or (= (L12_getmode) 3) (= (L12_getdimps) "1"))
	(setq L12_factor 1)
	(progn	
	(setq L12_factor (setq schaal (L12_getschaal)))
		(if (not (inPspace))
			(if(member "1:1" (_SortedScaleList (GetScaleListEntities)))
				(progn (setvar "CANNOSCALE" "1:1"))
				(progn (command "-scalelistedit" "a" "1:1" "1:1" "e")(setvar "CANNOSCALE" "1:1"))
			)
		)
	)
	)
	L12_factor
)

;;-----[ Functie om schaal door te sturen]-----------------------------------

(defun L12_setschaal (schaalold / )
(if (= (L12_getmode) 2)

	(progn ;normal
		(if (not (inPspace))
		(if(member "1:1" (_SortedScaleList (GetScaleListEntities)))
			(progn (setvar "CANNOSCALE" "1:1"))
			(progn (command "-scalelistedit" "a" "1:1" "1:1" "e")(setvar "CANNOSCALE" "1:1"))
		)
		)	
	(setvar "useri1" schaalold)
	(L12_dwgprops-set-custom-prop "L12_scale" (rtos schaalold) nil)
	)
	
	(progn ;anotative mode
		(setq schaalold (strcat "1:"(rtos schaalold 2 0)))
		(if (not (inPspace))
		(if(member schaalold (_SortedScaleList (GetScaleListEntities)))
			(progn (setvar "CANNOSCALE" schaalold))
			(progn (command "-scalelistedit" "a" schaalold schaalold "e")(setvar "CANNOSCALE" schaalold))
		)
		)
	(setvar "useri1" 0)
	(L12_dwgprops-set-custom-prop "L12_scale" "Annotative" nil)
	)
)
)

;;-----[ Functie die L12_Statusbar instelt]----------------------

(defun L12_Statusb ( / statuscolor statuslt statusla statussta staver val_useri1 val_useri2 val_userr2 staschaal)
 (setvar "cmdecho" 0)
 (setq statusla "-")
 (setq statussta "-")

 (Cond
   ((= ccCurColor "1") (setq statuscolor "Rood"))
   ((= ccCurColor "3") (setq statuscolor "Groen"))
   ((= ccCurColor "7") (setq statuscolor "Wit"))
   ((= ccCurColor "2") (setq statuscolor "Geel"))
   ((= ccCurColor "6") (setq statuscolor "Magenta"))
   ((= ccCurColor "4") (setq statuscolor "Cyaan"))
   ((= ccCurColor "5") (setq statuscolor "Blauw"))
   ((= ccCurColor "8") (setq statuscolor "Grijs"))
   (nil (setq statuscolor "-"))
 )
 (Cond
   ((= ccCurLType "CONTINUOUS") (setq statuslt "Co"))
   ((= ccCurLType "HIDDEN") (setq statuslt "Hi"))
   ((= ccCurLType "HIDDEN2") (setq statuslt "Hi2"))
   ((= ccCurLType "DASHDOT") (setq statuslt "Dd"))
   ((= ccCurLType "DASHDOT2") (setq statuslt "Dd2"))
   ((= ccCurLType "CENTER") (setq statuslt "Ce"))
   ((= ccCurLType "CENTER2") (setq statuslt "Ce2"))
   ((= ccCurLType "DIVIDE") (setq statuslt "Di"))
   ((= ccCurLType "DIVIDE2") (setq statuslt "Di2"))
   ((= ccCurLType "PHANTOM") (setq statuslt "Ph"))
   ((= ccCurLType "PHANTOM2") (setq statuslt "Ph2"))
   ((= ccCurLType "BORDER") (setq statuslt "Bo"))
   ((= ccCurLType "BORDER2") (setq statuslt "Bo2"))
   ((= ccCurLType "DASHED") (setq statuslt "Da"))
   ((= ccCurLType "DASHED2") (setq statuslt "Da2"))
   (nil (setq statuslt "-"))
 )
(if (L12_mark)
(progn
	(setq staver (strcat "Lab"(rtos L12_Lab_version 2 2)))
	(Cond
	((= (L12_getlang) 1) (setq statusla "NL"))
	((= (L12_getlang) 2) (setq statusla "FR"))
	((= (L12_getlang) 3) (setq statusla "EN"))
	)
	(setq statussta (L12_standaard_Statusb))
	(if (= (L12_getmode) 2)
	(setq staschaal (strcat "1:" (rtos (L12_getschaal) 2 0)))
	(setq staschaal "-->")
	)
)
(progn
	(setq staver  (strcat "Lab"(rtos L12_Lab_version 2 2)" not set"))
	(setq staschaal "-")
)
)	
  (setvar "modemacro" (strcat staver " | " statuscolor " | " statuslt " | " statusla " | " statussta " | " staschaal ))
  (setvar "cmdecho" 1)
)

;;-----[ Functie om layer naar oorspronkelijk terug te plaatsen]-----------------------------------

(defun terug ( / )
    (princ)
    (command "layer" "s" c2 "")
) ;

;;-----[ Functie check basepoint]-----------------------------------

(defun  L12_basecheck ( / curbase )
  (setq curbase (getvar "insbase" ))
;  (if (not(and(= (rtos(nth 0 curbase) 2 0) "0")(= (rtos(nth 1 curbase) 2 0) "0")(= (rtos(nth 2 curbase)2 0) "0")))
  (if (not(and(= (nth 0 curbase) 0)(= (nth 1 curbase) 0)(= (nth 2 curbase) 0)))
  (alert "Basepoint of the drawing isn't 0,0,0\nType 'base' in the command line to modify.")
  )
  (princ)
)

;;-----[ Functie check if in paperspace]-----------------------------------

(defun inPSPACE ( / )
  (and
    (zerop (getvar "TILEMODE"))
    (zerop (getvar "VPMAXIMIZEDSTATE"))
    (eq (getvar "CVPORT") 1)
  )
)

;;-----[ Functies die lijsten manipuleren voor DCL files]----------------

(defun set_tile_list (KeyName$ ListName@ Selected / Item)
  (start_list KeyName$ 3)
  (mapcar 'add_list ListName@)
  (end_list)
  (foreach Item (if (listp Selected) Selected (list Selected))
   (if (member Item ListName@)
     (set_tile KeyName$ (itoa (- (length ListName@) (length (member Item ListName@)))))
   );if
  );foreach
);defun set_tile_list

(defun check_editint (SentVar$ / Cnt# Mid$ Passed SubVar$)
  (setq SubVar$ (eval (read SentVar$)))
  (setq Cnt# 1 Passed t)
  (repeat (strlen $value)
    (setq Mid$ (substr $value Cnt# 1))
    (if (not (member Mid$ (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9")))
      (setq Passed nil)
    );if
    (setq Cnt# (1+ Cnt#))
  );repeat
  (if (not Passed)
    (progn
      (alert "Value must be an integer!")
      (set_tile $key SubVar$)
    );progn
    (if (= $value "")
      (set (read SentVar$) $value)
      (progn
        (setq $value (itoa (atoi $value)))
        (set (read SentVar$) $value)
        (set_tile $key $value)
      );progn
    );if
  );if
  (princ)
);defun check_editint

(defun set_list_value (SentList$ SentVar$ / SaveVar$ SubList@)
  (setq SubList@ (eval (read SentList$)))
  (setq SaveVar$ (eval (read SentVar$)))
  (set (read SentVar$) (nth (atoi $value) SubList@))
  (if (= (eval (read SentVar$)) "")
    (progn
      (set (read SentVar$) SaveVar$)
      (set_tile_list $key SubList@ SaveVar$)
    );progn
  );if
  (princ)
);defun set_list_value

(defun L12_MyYesNo (Title$ Question$ / Answer$ Dcl_Id% Return#)
  (princ "\nMyYesNo")(princ)
  ; Load Dialog
  (setq Dcl_Id% (load_dialog "LAB2012.dcl"))
  (new_dialog "LabYesNo" Dcl_Id%)
  ; Set Dialog Initial Settings
  (set_tile "Title" Title$)
  (set_tile "Title2" Question$)
  ; Dialog Actions
  (action_tile "Yes" "(done_dialog 1)")
  (action_tile "No" "(done_dialog 0)")
  (setq Return# (start_dialog))
  ; Unload Dialog
  (unload_dialog Dcl_Id%)
  (if (= Return# 1)
    (setq Answer$ "Yes")
    (setq Answer$ "No")
  );if
  (princ "\n")(princ Answer$)(princ);Optional
  Answer$
);defun LabYesNo

;(vlr-remove-all)
;(setq mySavereactor nil)
;(if (null mySaveReactor)(progn
;(setq reactorCallbacks '((:vlr-commandended . myCallback)))
;(setq mySaveReactor (vlr-command-reactor 1 reactorCallbacks))
;))

;(defun myCallback (R CL)
;(cond
;  ((member(car cl) '("ZOOM" "REDRAW" "REGEN" "REGENALL" "PAN" "U" "MREDO"))
  ;do nothing
;  )
;  ((member(car cl) '("save" "qsave" "saveas"))
;   (vlr-data-set r 1)) ;setcounter to 0
;   ((= 50 (vlr-data R));put your number here
;   (if (= (L12_MyYesNo "Do you wish to save" "You should be saving your drawing") "Yes")(command "qsave"))
;   (vlr-data-set r 1))
;   (t (vlr-data-set r (1+ (vlr-data r))))
;   ))
   
;(if (null *autosave-reactor*)
    (setq *autosave-reactor*
        (vlr-command-reactor "autosave"
           '(
                (:vlr-commandended     . autosave)
 ;               (:vlr-commandcancelled . autosave)
 ;               (:vlr-commandfailed    . autosave)
            )
        )
    )
;)
(setq *autosave-acdoc* (vla-get-activedocument (vlax-get-acad-object))
      *autosave-count* 0
)


(defun autosave ( obj arg )
    (if (and 
				(/= 0 gl_autosave)
				(zerop (rem (setq *autosave-count* (1+ *autosave-count*)) gl_autosave))
				(= 1 (getvar 'dwgtitled))
        )
        (if (= (L12_MyYesNo "You should be saving your drawing!" "Do you wish to save now?") "Yes")(vla-save *autosave-acdoc*))
    )
    (princ)
)
(princ)

(vlr-docmanager-reactor
 nil
  '((:vlr-documentToBeActivated . L12_Statusb_reactor))
)

(defun L12_Statusb_reactor (mac_reactor mac_info /)
(L12_Statusb)
(setvar "UCSICON" 1)
(setvar "dblclkedit" 1)
)

(defun DeleteFolder (path / fso path)
  (if (and (setq fso (vlax-get-or-create-object "Scripting.FileSystemObject"))
           (= -1 (vlax-invoke fso 'folderexists path)))
    (progn
      (vlax-invoke (vlax-invoke fso 'getfolder path) 'delete)
      (vlax-release-object fso)))
  (princ)
)

(defun CopyFolder (source target / fso)
  (setq FSO (vlax-create-object "Scripting.FilesystemObject"))
  (if (= -1 (vlax-invoke fso 'folderexists source))
    (vlax-invoke fso 'copyfolder source target)
  )
  (vlax-release-object fso)
)

(defun L12_GetFileFromURL  (url path / utilObj tempPath newPath)
  ;; © RenderMan 2011, CADTutor.net
  ;; Example: (download "http://www.indiesmiles.com/wp-conten...0/12/SMILE.jpg" (getvar 'dwgprefix))
  (vl-load-com)
  (setq utilObj (vla-get-utility
                  (vla-get-activedocument (vlax-get-acad-object))))
  (if (= :vlax-true (vla-isurl utilObj url))
    (if (vl-catch-all-error-p
          (vl-catch-all-apply
            'vla-GetRemoteFile
            (list utilObj url 'tempPath :vlax-true)))
      (prompt "\n  <!>  Error Downloading File From URL  <!> ")
      (progn
        (if (findfile
              (setq newPath
                     (strcat path
                             (vl-filename-base url)
                             (vl-filename-extension url))))
          (vl-file-rename
            newPath
            (setq voidPath
                   (strcat
                     (vl-filename-directory newPath)
                     "\\void_"
                     (vl-filename-base newPath)
                     "_"
                     (menucmd
                       "M=$(edtime,$(getvar,date),YYYY-MO-DD-HH-MM-SS)")
                     (vl-filename-extension newPath)))))
        (vl-file-copy tempPath newPath)
        (vl-file-delete tempPath)))
    (prompt "\n  <!>  Invalid URL  <!> "))
  (vl-catch-all-apply 'vlax-release-object (list utilObj))
  (princ)
 )
 
 (defun L12_getdate (/ AP CL DN CD MX MN MO YR)
    (setq 
          CD (rtos (getvar "CDATE") 2 4)
          MX (atoi (substr CD 5 2))
          MN (substr CD 12 2)
          MO (nth MX '(nil "Jan" "Feb" "Mrt" "Apr" "Mei" "Jun"
                           "Jul" "Aug" "Sep" "Okt" "Nov" "Dec"))
    )
    (setq YR (strcat (substr CD 7 2)"-" MO "-'" (substr CD 3 2)))
	YR
 )
 
 (defun DegreesToRadians (numberOfDegrees) 
   (* pi (/ numberOfDegrees 180.0))
 )
 
 (defun L12_readblock ( / ent blk_data )
 	(setq ent  (entsel "\nSelect GMI Titleblock:"))
	(setq blk_data nil)
	(if ent
	(progn
	(setq ent (entget (car ent)))
	(while ent
	(setq ent (entget (entnext (cdr (assoc -1 ent)))))
	(if (assoc 1 ent)
	(setq blk_data (append blk_data (list (cdr (assoc 1 ent)))))
	)
	(if (not (= (cdr (assoc 0 ent)) "ATTRIB"))(setq ent nil))
	)
	)
	)
	blk_data
	(princ)
)
;;; *********************************************** *************************
;;; * Library DWGruLispLib Copyright © 2007 DWGru Programmers Group 
;;; * 
;;; * L12_Dwgprops-get-all-prop 
;;; * 
;;; * 27/12/2007 Version 0001. Vladimir Azarko (VVA) 
;;; *********************************************** *************************

(defun L12_dwgprops-get-all-prop (Doc / si ret nc key value) 
;;; Returns the file's properties, set the command _dwgprops 
;;; Returns an associative list, where the key is: 
;; - For properties created by the user (tab OTHER) 
;;; Property name 
;; - For standard properties (tab PAPER) 
;;; Key field 
;;; NAME - *TITLE* 
;;; AUTHOR - *AUTHOR* 
;;; TOPIC - *SUBJECT* 
;;; KEY WORDS - *KEYWORDS* 
;;; NOTES - *COMMENTS* 
;;; Hyperlink Base - *HYPERLINK* 
;;;!! Key fields are converted to uppercase 
;;; Doc - a pointer to the  document, nil - the current 
   
;;; Example 
;;; (L12_dwgprops-get-all-prop nil) ;;;(("* AUTHOR * "" VVA ") (" * COMMENTS * "" Memo ") (" * HYPERLINK * "" Base ") 
                                ;;;("* KEYWORDS * "" Key ") (" * TITLE * "" named ") (" * SUBJECT * "" R ") (" UNIQKEY "" Key ")) 

(and
(or Doc
    (setq Doc (vla-get-activeDocument (vlax-get-acad-object)))
    )
(setq si (vla-get-SummaryInfo Doc))
(setq ret (list
	    (list "*AUTHOR*" (vla-get-author si))
	    (list "*COMMENTS*" (vla-get-comments si))
            (list "*HYPERLINK*" (vla-get-HyperlinkBase si))
	    (list "*KEYWORDS*" (vla-get-keywords si))
            (list "*TITLE*" (vla-get-Title si))
	    (list "*SUBJECT*" (vla-get-Subject si))
	    )
)
(setq nc (vla-numcustominfo si))
(while (> nc 0) 
(vla-GetCustomByIndex si (- nc 1) 'key 'value)
(setq ret (append ret (list(list (strcase key) value))))  
(setq nc (1- nc))
)
(vlax-release-object si)
)
 ret
)   
;;; *********************************************** *************************
;;; * Library DWGruLispLib Copyright © 2007 DWGru Programmers Group 
;;; * 
;;; * L12_Dwgprops-get-custom-prop 
;;; * 
;;; * 27/12/2007 Version 0001. Vladimir Azarko (VVA) 
;;; *********************************************** *************************


(defun L12_dwgprops-get-custom-prop (key Doc / app counter counter2 counter3 doc dwgprops kv) 
;;; Returns the value of the property created by the user (command _dwgprops) 
;;; Returns an associative list, where the key is: 
;; - For properties created by the user (tab OTHER) 
;;; Key - a string property name (tab OTHER) 
;; - For standard properties (tab PAPER) 
;;; Key field 
;;; NAME - *TITLE* 
;;; AUTHOR - *AUTHOR* 
;;; TOPIC - *SUBJECT* 
;;; KEY WORDS - *KEYWORDS* 
;;; NOTES - *COMMENTS* 
;;; Hyperlink Base - *HYPERLINK* 
;;; 
;;; Uses the library 
;;; L12_Dwgprops-get-all-prop 
;;; L12_Assoc (L12_assoc-multi) 
   
;;; Doc - a pointer to the  document, nil - the current 
   
  (cadr (L12_assoc key (L12_dwgprops-get-all-prop Doc))) 
) 
;;; *********************************************** *************************
;;; * Library DWGruLispLib Copyright © 2007 DWGru Programmers Group 
;;; * 
;;; * L12_Dwgprops-set-custom-prop 
;;; * 
;;; * 27/12/2007 Version 0001. Vladimir Azarko (VVA) 
;;; *********************************************** *************************

(defun L12_dwgprops-set-custom-prop (key value Doc / si) 
;;, Create in the properties of the figure (team _dwgprops bookmark OTHER) 
;;; Property with key and value value 
;;; If the property was not, it is created, otherwise the changes 
;;; Key - a string property name (tab OTHER) 
;;; Value - a string  - value of property 
;;; Uses the library 
;;; L12_Dwgprops-get-custom-prop 
;;; Doc - a pointer to the document, nil - the current 
;;; Returns - nil 
;;; Example 
;;; (L12_dwgprops-set-custom-prop "dwgru" "dwgru-dwgprops-set-custom-prop" nil) 

   (or Doc 
   (setq Doc (vla-Get-ActiveDocument (vlax-Get-Acad-Object))) 
     ) 
   (setq si (vla-Get-SummaryInfo Doc)) 
   (if (L12_dwgprops-get-custom-prop key Doc) 
     (vla-SetCustomByKey si key value) 
     (vla-AddCustomInfo si key value) 
   ) 
) 



(defun L12_assoc-multi (key lst) 
   (if (= (type key) 'str) 
     (setq key (strcase key)) 
     ); _ End of if 
   (vl-remove-if-not 
     (function 
       (lambda (a / b) 
         (and (setq b (car a)) 
              (or (and (= (type b) 'str) (= (strcase b) key)) (equal b key)) 
              ); _ End of and 
         ); _ End of lambda 
       ); _ End of function 
     lst 
     ); _ End of vl-remove-if-not 
   ); _ End of defun 
(defun L12_assoc (key lst) 
   (car (L12_assoc-multi key lst)) 
   ); _ End of defun



