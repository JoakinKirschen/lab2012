 
;; Increment Text lisp routine
;;
;; by: Irné Barnard
;; Version 1.3
;; 
;; Version history
;; ==================================
;;
;; 1.3
;; Fixed to work with Annotative Objects
;; Added function to include dialog interface inside LSP_ file
;;
;; 1.2
;; Added alphabetic increments
;;
;; 1.1
;; Add prefix / suffix
;; Add minimum digits
;;
;; 1.0
;; Initial version
;;
;; Read from registry is exists


(vl-load-com) ;Ver 1.3 added to load VLisp extensions

(setq alphalst '("A" "B" "C" "D" "E" "F" "G" "H" "J" "K" "L" "M" "N" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")) ;_ end of setq
(defun getINCRset ( / INCRset)
(if (setq INCRset (getenv "IncrementSetting"))
	(setq INCRset (read INCRset))
	(setq	INCRset	 '(1 "" "" 1 1 t))
)
)
;; Utility function to convert alpha number to integer
;|(defun alphatoi (a / i neg n)
  (if (setq neg (= "-" (substr a 1 1)))
    (setq a (substr a 2))
  )
  (setq i a n (strlen i) a "")
  (while (> n 0)
    (setq a (strcat a (substr i n 1)) n (1- n))
  )
  (setq i 0 n 1)
  (while (<= n (strlen a))
    (if (= n (strlen a))
      ()
      (setq i (+ i (* (vl-position (1- n) )
    )
    (setq n (1+ n))
  )

  (if neg (setq i (* i -1)))
  i
)
|;

;; Utility function to convert integer to Alpha number
(defun itoalpha	(i / a neg)
	(setq	neg	(< i 0)
				i		(abs (fix i))
				a		""
	) ;_ end of setq
	(while (>= i 0)
		(setq a (strcat (nth (rem i (length alphalst)) alphalst) a))
		(setq i (- i (rem i (length alphalst))))
		(setq i (fix (/ i (length alphalst))))
		(if	(= i 0)
			(setq i -1)
			(if	(/= (rem i) 0)
				(setq i (1- i))
			) ;_ end of if
		) ;_ end of if
	) ;_ end of while
	(if	neg
		(setq a (strcat "-" a))
	) ;_ end of if
	a
) ;_ end of defun

;; Command to increment text values by picking
(defun c:Increment (/ dcl_id obj objid id quit rate start value prfx sufx digits numerals)
	(setq INCRset (getINCRset))
	(setq	start		 (nth 0 INCRset)
				prfx		 (nth 1 INCRset)
				sufx		 (nth 2 INCRset)
				rate		 (nth 3 INCRset)
				digits	 (nth 4 INCRset)
				numerals (nth 5 INCRset)
	) ;_ end of setq

	(defun Setup ()
		;; (setq DCL_ID (load_dialog "Increment.DCL")) ;Removed for 1.3
		(setq DCL_ID (load_dialog_Increment)) ;Added for 1.3
		(if	(not (new_dialog "increment" DCL_ID))
			(exit)
		) ;_ end of if
		(defun CHECKOUT	()
			(setq start (atoi (get_tile "start")))
			(setq	prfx (get_tile "prefix")
						sufx (get_tile "sufix")
			) ;_ end of setq
			(setq	rate (if (= (atoi (get_tile "one")) 1)
									 "1"
									 (if (= (atoi (get_tile "two")) 1)
										 "2"
										 "0"
									 ) ;_ end of if
								 ) ;_ end of if
			) ;_ end of setq
			(setq	rate (atoi (if (/= (atoi (get_tile "increase")) 1)
												 (strcat "-" rate)
												 rate
											 ) ;_ end of if
								 ) ;_ end of atoi
			) ;_ end of setq
			(setq digits (atoi (get_tile "digits")))
			(setq numerals (= (get_tile "num") "1"))
			(setq INCRset (list start prfx sufx rate digits numerals))
			(setenv "IncrementSetting" (vl-prin1-to-string INCRset))
		) ;_ end of defun
		(defun DONE	()
			(setq quit 1)
		) ;_ end of defun
		(if	(/= start nil)
			(set_tile "start" (itoa start))
		) ;_ end of if
		(if	(/= prfx nil)
			(set_tile "prefix" prfx)
		) ;_ end of if
		(if	(/= sufx nil)
			(set_tile "sufix" sufx)
		) ;_ end of if
		(if	(/= digits nil)
			(set_tile "digits" (itoa digits))
		) ;_ end of if
		(if	numerals
			(set_tile "num" "1")
			(set_tile "alpha" "1")
		) ;_ end of if
		(if	(/= rate nil)
			(progn
				(cond
					((= rate 0) (set_tile "none" "1"))
					((= rate 2) (set_tile "two" "1"))
					((= rate -2) (set_tile "two" "1") (set_tile "decrease" "1"))
					((= rate -1) (set_tile "decrease" "1"))
				) ;_ end of cond
			) ;_ end of progn
		) ;_ end of if
		(action_tile "accept" "(CHECKOUT)(done_dialog)")
		(action_tile "cancel" "(DONE)(done_dialog)")
		(start_dialog)
		(unload_dialog DCL_ID)
	) ;_ end of defun
	(SETUP)
	(while (/= quit 1)
		(while (and (/= quit 1) (not (or (= id "TEXT") (= id "MTEXT") (= id "ATTRIB"))))
			(setq obj nil)
			(if	numerals
				(progn
					(setq value (itoa start))
					(while (< (strlen value) digits) (setq value (strcat "0" value)))
				) ;_ end of progn
				(progn
					(setq value (itoalpha start))
					(while (< (strlen value) digits) (setq value (strcat "*" value)))
				) ;_ end of progn
			) ;_ end of if
			(while (and (/= quit 1) (= obj nil))
				(setvar "errno" 0)
				(initget 4 "Change")
				(setq obj (nentsel (strcat "\rSelect text...(" value ")[Change]")))
				(cond
					((= (getvar "errno") 52)
					 (setq quit	1
								 obj 1
					 ) ;_ end of setq
					)
					((= obj "Change") (Setup) (setq obj nil))
					((/= obj nil) (setq objid (entget (car obj))) (setq id (cdr (assoc 0 objid))))
				) ;_ end of cond
			) ;_ end of while
		) ;_ end of while
		(if	(/= quit 1)
			(progn
				;(setq objid (subst (cons 1 (strcat prfx value sufx)) (assoc 1 objid) objid))
				;(entmod (list (assoc -1 objid) (cons 1 (strcat prfx value sufx))))
				;; Version 1.3 changed to use ActiveX
				(vla-put-TextString (vlax-ename->vla-object (car obj)) (strcat prfx value sufx))
				(command "_updatefield" (car obj) "")
				(entupd (car obj))
				(setq INCRset (list start prfx sufx rate digits numerals))
				(setq start (+ start rate))
				(setq id nil)
				(setq obj nil)
			) ;_ end of progn
		) ;_ end of if
	) ;_ end of while
	(princ)
) ;_ end of defun

;;; Function to load Increment dialog
;;; Added at revision 1.3
(defun load_dialog_Increment (/ fn f)
  (setq fn (strcat (getvar "TEMPPREFIX") "Increment.DCL"))
  (setq f (open fn "w"))
  (write-line "//" f)
  (write-line "// Increment text Dialog Box definition" f)
  (write-line "//" f)
  (write-line "// by: Irné Barnard" f)
  (write-line "// Version 1.2" f)
  (write-line "// " f)
  (write-line "// Version history" f)
  (write-line "// ==================================" f)
  (write-line "// 1.2" f)
  (write-line "// Added alphabetic increments" f)
  (write-line "//" f)
  (write-line "// 1.1" f)
  (write-line "// Add prefix / suffix" f)
  (write-line "// Add minimum digits" f)
  (write-line "//" f)
  (write-line "// 1.0" f)
  (write-line "// Initial version" f)
  (write-line "//" f)
  (write-line "increment : dialog {" f)
  (write-line "            label = \"Increment Parameters\";" f)
  (write-line "              initial_focus = \"start\";" f)
  (write-line "              : column {" f)
  (write-line "                : row { : edit_box {" f)
  (write-line "                  label = \"Starting Number:\";" f)
  (write-line "                  value = \"1\";" f)
  (write-line "                  key = \"start\";" f)
  (write-line "                }" f)
  (write-line "                : edit_box {" f)
  (write-line "                  label = \"Min. Digits:\";" f)
  (write-line "                  value = \"1\";" f)
  (write-line "                  key = \"digits\";" f)
  (write-line "                }}" f)
  (write-line "                : row { : edit_box {" f)
  (write-line "                  label = \"Prefix:\";" f)
  (write-line "                  value = \"\";" f)
  (write-line "                  key = \"prefix\";" f)
  (write-line "                }" f)
  (write-line "                : edit_box {" f)
  (write-line "                  label = \"Sufix:\";" f)
  (write-line "                  value = \"\";" f)
  (write-line "                  key = \"sufix\";" f)
  (write-line "                }}" f)
  (write-line "                :row {" f)
  (write-line "                  : boxed_radio_column {" f)
  (write-line "                    label = \"Direction\";" f)
  (write-line "                    : radio_button {" f)
  (write-line "                      label = \"Increase\";" f)
  (write-line "                      value = \"1\";" f)
  (write-line "                      key = \"increase\";" f)
  (write-line "                    }" f)
  (write-line "                    : radio_button {" f)
  (write-line "                      label = \"Decrease\";" f)
  (write-line "                      value = \"0\";" f)
  (write-line "                      key = \"decrease\";" f)
  (write-line "                    }" f)
  (write-line "                  }" f)
  (write-line "                  : boxed_radio_column {" f)
  (write-line "                    label = \"Type\";" f)
  (write-line "                    //is_enabled = false;" f)
  (write-line "                    : radio_button {" f)
  (write-line "                      label = \"Numerals\";" f)
  (write-line "                      value = \"1\";" f)
  (write-line "                      key = \"num\";" f)
  (write-line "                      //is_enabled = false;" f)
  (write-line "                    }" f)
  (write-line "                    : radio_button {" f)
  (write-line "                      label = \"Alphabet\";" f)
  (write-line "                      value = \"0\";" f)
  (write-line "                      key = \"alpha\";" f)
  (write-line "                      //is_enabled = false;" f)
  (write-line "                    }" f)
  (write-line "                  }" f)
  (write-line "                " f)
  (write-line "                : boxed_radio_column {" f)
  (write-line "                  label = \"Rate\";" f)
  (write-line "                  : radio_button {" f)
  (write-line "                    label = \"One\";" f)
  (write-line "                    value = \"1\";" f)
  (write-line "                    key = \"one\";" f)
  (write-line "                  }" f)
  (write-line "                  : radio_button {" f)
  (write-line "                    label = \"Two\";" f)
  (write-line "                    value = \"0\";" f)
  (write-line "                    key = \"two\";" f)
  (write-line "                  }" f)
  (write-line "                  : radio_button {" f)
  (write-line "                    label = \"None\";" f)
  (write-line "                    value = \"0\";" f)
  (write-line "                    key = \"none\";" f)
  (write-line "                  }" f)
  (write-line "                }}" f)
  (write-line "              }" f)
  (write-line "              ok_cancel;" f)
  (write-line "}" f)
  (close f)
  (load_dialog fn)
) ;_ end of defun

(princ)
 ;|«Visual LISP© Format Options»
(120 2 40 2 T "end of " 80 9 0 0 1 T T nil T)
;*** DO NOT add text below the comment! ***|;
