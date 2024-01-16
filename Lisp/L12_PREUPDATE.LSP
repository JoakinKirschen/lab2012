;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_PREUPDATE ()
(princ "L12_PREUPDATE is loaded")
(princ)
)

(defun C:L12Update ( / temp )
 (initerr)  (setvar "cmdecho" 0)
 (setq temp (L12_vercheck))
 (if (= temp 1)
 (L12_update) 
 (if (= temp 0)
 (alert "U already have the latest version of lab 2012")
 )
 )
 (reset)
 (princ)
)

(defun needupdate ( / dateint1 dateint2 dateint3 date filedate1 filedate2 filedate3 CurDate setting *error*)
  (defun *error* ( msg )
    (if (not (member msg '("Function cancelled" "quit / exit abort")))
		(progn 	(setenv "L12_UpdateSettings" (vl-princ-to-string 2))
			(setenv "L12_Datestamp" (vl-prin1-to-string (atoi (substr (rtos (getvar "CDATE") 2 0) 1 8))))
			(alert "Environment has been reset.\nRetry your command.\nIf problems persists contact JOKI.")
		)
    )
    (princ)
  )
	(setq CurDate (rtos (getvar "CDATE") 2 0))
	(setq dateint1 (atoi (substr CurDate 1 8)))
	(setq dateint2 (atoi (substr CurDate 1 7)))
	(setq dateint3 (atoi (substr CurDate 1 6)))
	(if (getenv "L12_UpdateSettings")
	(setq setting (read(getenv "L12_UpdateSettings")))
	(progn (setq setting 2) (setenv "L12_UpdateSettings" (vl-princ-to-string 2)))
	)
	
(if (= setting 1)	
	(progn
	(if (setq filedate1 (getenv "L12_Datestamp"));Read from registry
	(progn
		(setq filedate1 (read filedate1))
		(if (< filedate1 dateint1)
			(progn
				(setenv "L12_Datestamp" (vl-prin1-to-string dateint1))
				(if (= (L12_vercheck) 1)(L12_update))
			)
		)
		)
		(progn
		(setenv "L12_Datestamp" (vl-prin1-to-string dateint1))
		(if (= (L12_vercheck) 1)(L12_update))
		)
	)		
	)
)
(if (= setting 2)	
	(progn
	(if (setq filedate2 (getenv "L12_Datestamp"));Read from registry
		(progn
		(setq filedate2 (atoi(substr (itoa (read filedate2)) 1 7)))
		(if (< filedate2 dateint2)
			(progn
				(setenv "L12_Datestamp" (vl-prin1-to-string dateint1))
				(if (= (L12_vercheck) 1)(L12_update))
			)
		)
		)
		(progn
		(setenv "L12_Datestamp" (vl-prin1-to-string dateint1))
		(if (= (L12_vercheck) 1)(L12_update))
		)	
	)		
	)
)
(if (= setting 3)	
	(progn
	(if (setq filedate3 (getenv "L12_Datestamp"));Read from registry
		(progn
		(setq filedate3 (atoi(substr (itoa (read filedate2)) 1 6)))
		(if (< filedate3 dateint2)
			(progn
				(setenv "L12_Datestamp" (vl-prin1-to-string dateint1))
				(if (= (L12_vercheck) 1)(L12_update))
			)
		)
		)
		(progn
		(setenv "L12_Datestamp" (vl-prin1-to-string dateint1))
		(if (= (L12_vercheck) 1)(L12_update))
		)
	)		
	)
)
    ;Save to registry
	(princ)
)


(defun LabUpdate1 ( / temp list1 Dcl_Id%)
	(setq Dcl_Id% (load_dialog "LAB2012.dcl"))
	(if (not (new_dialog "LabUpdate1" Dcl_Id%))
	(exit))
	(action_tile "delay" "(setq temp 0)(done_dialog)")
	(action_tile "next" "(setq temp 1)(done_dialog)")
	(action_tile "settings" "(setq temp 2)(done_dialog)")
	(start_dialog)
	(unload_dialog Dcl_Id%)
	(setq list1 (list temp ))
	(if (= temp 1) (LabUpdate2) 
	(if (= temp 2) (progn (c:L12_Settings) (LabUpdate1)) ;nog te bekijken
	list1
	)
	)
)

(defun LabUpdate2 ( / temp toggle1$ list1 Dcl_Id%)
	(setq Dcl_Id% (load_dialog "LAB2012.dcl"))
	(if (not (new_dialog "LabUpdate2" Dcl_Id%))
	(exit))
	(setq toggle1$ 0)
	(action_tile "toggle1" "(setq toggle1$ $value)")
	(action_tile "previous" "(setq temp 1)(done_dialog)")
	(action_tile "delay" "(setq temp 0)(done_dialog)")
	(action_tile "install" "(setq temp 2)(done_dialog)")
	(setq Return# (start_dialog))
	(unload_dialog Dcl_Id%)
	(setq list1 (list temp toggle1$))
	(if (= temp 1) (LabUpdate1)
	list1
	)
)
(prompt "\ncheck")

(defun L12_vercheck ( / vcheck newverint fp lst tmp temppath)
	;(setq temppath (strcat (getenv "Temp") "\\"))
	;(L12_GetFileFromURL "http://www.kitek.be/Website/lab2012/lab_version.txt" temppath)
	;(setq tmp (strcat temppath "lab_version.txt"))	
	;(if (setq tmp (getenv "L12_UpdatePath"))
	;(if (findfile tmp)
	;(progn
	;(progn
	;		(setq fp (open tmp "r") )
	;		(while (setq l (read-line fp))
	;		(setq lst (cons l lst))
	;		)
	;		(close fp)
	;		(setq lst (reverse lst))
 ;   )
	(setq temppath (strcat (getenv "Temp") "\\"))
	(setq tempfile (strcat temppath "lab_version.txt"))
;	(KTS_GetFileFromURL "http://www.kitek.be/data/kts_version.txt" temppath)

	(if (findfile tempfile)
		(vl-file-delete tempfile)
	)

	(setq scriptfile (findfile "L12_dl.vbs")) ;calls external VBScript to kill Excel instance
	(startapp (strcat "CSCRIPT.EXE //nologo " (vl-prin1-to-string scriptfile) " " (vl-prin1-to-string "https://github.com/JoakinKirschen/lab2012/raw/master/lab_version.txt")))
	(setq count 0)
	(while (and (<= count 30)(not (findfile tempfile)))	(L12_wait 1)(princ "/")(setq count (+ count 1))	)
	
	(if (findfile tempfile)
	(progn
	(progn
		(setq fp (open tempfile "r") )
		(while (setq l (read-line fp))(setq lst (cons l lst)))
		(close fp)
		(setq lst (reverse lst))
    )
	
	(if (/= lst nil)
	(progn	
	(setq newverint  (atof (nth 0 lst)))
	(if (< L12_Lab_version newverint)
	(setq vcheck 1)
	(setq vcheck 0)
	)
	;(vl-file-delete  tmp)
	(princ (strcat "\nCurrent version: " (rtos L12_Lab_version) "\nOnline  version: " (rtos newverint)"\n")) 
	)
	(progn
	(princ "\nFile not found.\n")
	(c:L12_Settings)
	(setq vcheck 2)
	)
	)
    )
	)
;	(progn
;		(princ "\nUpdate path not set.\n")
;		(c:L12_Settings)
;		(setq vcheck 2)
;	)
;	)		
	vcheck
)

(defun L12_update ( / list1 LabPathSource test temp maincuifile)
   ;Default paden
  (setq maincuifile (vl-filename-base (vla-get-menufile (vla-get-files (vla-get-preferences (vlax-get-acad-object))))))
  (if (or (= maincuifile "Lab2012") (= maincuifile "lab2012")(= maincuifile "LAB2012"))
  (progn
  (alert "Update not possible.\n\nYou shouldn't be using Lab2012 as your main CUI file.\nFor more information check the Lab2012 help file.")
  (exit)
  )
  ) 
  ;(setq LabPathSource (strcat (vl-filename-directory (getenv "L12_UpdatePath"))"\\LAB2012"  ))
  (setq list1 (LabUpdate1))
  (setq temp  (nth 0 list1))
  (if (= temp 2)
  (if (vl-file-directory-p LabPathDest)
  (progn
  (princ "\nDownloading Files")
  (setq test 0)
  ;(if (not (vl-file-directory-p (strcat LabPathDest "\\lisp")))
  ;(vl-mkdir (strcat LabPathDest "\\lisp")))
  ;(vl-file-delete  (strcat LabPathDest "\\lisp\\L12_RUNUPDATE.lsp"))
  ;(vl-file-copy    (strcat LabPathSource "\\lisp\\L12_RUNUPDATE.lsp") (strcat LabPathDest "\\lisp\\L12_RUNUPDATE.lsp"))
  (cond 
  ((null updatefunction) (load (strcat LabPathDest "\\lisp\\L12_RUNUPDATE.lsp"))(updatefunction LabPathDest list1)(setq Test 1))
  )
  (if (= test 0)
  (alert "Update not possible.\nPlease restart AutoCad before updating.")
  )
  )
  (alert (strcat "Update not possible.\nMake sure Lab2012 is installed on " LabPathDest ))
  )
  )
  (princ)
)

(defun L12_wait (seconds / stop)
(setq stop (+ (getvar "DATE") (/ seconds 86400.0)))
(while (> stop (getvar "DATE")))
);defun
