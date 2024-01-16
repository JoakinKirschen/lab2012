;***********************************************************************
; HELLING.LSP
;***********************************************************************
; UF001
; Error handling routine
(defun tal_err(*e)
  (if (/= *e "tal")
    (princ (strcat "\nError:" *e))
    )
  (setq *e nil)
  (put_sys_vars)
  (setq *error* olderr)
  (princ)
  )

; UF002
; Push system variables
(defun get_sys_vars()
  (setq oldcmd 	(getvar "CMDECHO")
		oldos	(getvar "OSMODE")
	)
  (princ)
  )

; UF003
; Pop system variables
(defun put_sys_vars()
  (setvar "OSMODE" oldos)
  (setvar "CMDECHO" oldcmd)
  (princ)
  )

; UF004
; Set system variables
(defun set_sys_vars()
 (setq cmd (getvar "cmdecho" ))  (setvar "cmdecho" 0)
  (princ)
  )

; UF005
; Get object
; -----------------------------------------------------
; Parameters
; p:str:otype = required object type i.e "LINE"
; p:str:prompt = command prompt i.e "\nSelect a line:"

(defun ut-get-object (p:str:otype p:str:prompt / es en el et)
  ; select object
  (setq es nil)
  (while (= es nil)
	(setq es (entsel p:str:prompt))
	(if (/= es nil)
	  (progn
		(setq en (car es)
			  el (entget en)
			  et (cdr (assoc 0 el))
			  )
		(if (/= et p:str:otype)
		  (setq es nil)
		  )
		)
	  )
	)
  ; return entity list
  el
  )

; <----------------------- HELLING  -------------------------->

(defun C:HELLING ( / olderr p1 p2 el x1 y1 z1 x2 y2 z2 d)
  (get_sys_vars)
  (set_sys_vars)
  (setq olderr *error* *error* tal_err)
  ;; Get two points or an entity
  (initget 0 "Line")

  (setq p1 (getpoint "\nFirst point or [Line]: "))
  (if (= p1 nil)
	(setq p1 "Line")
	)

  (if (= p1 "Line")
	; true
	(progn
	  (setq el (ut-get-object "LINE" "\nSelect a line:"))
	  (setq p1 (cdr (assoc 10 el)))
	  (setq p2 (cdr (assoc 11 el)))
	 )
	; false
	(progn
	  (setq p2 (getpoint p1 "\nSelect second point: "))
	  )
	)
  (if (= p2 nil) (exit))

  ; points
  (setq x1 (car p1)
		y1 (cadr p1)
		z1 (caddr p1)
		x2 (car p2)
		y2 (cadr p2)
		z2 (caddr p2)
		)
  ; HELLING
  (if (> (abs (- z1 z2)) 0.1)
	(setq s1 "3D"
		  p1 (subst 0.0 z1 p1)
		  p2 (subst 0.0 z2 p2)
		  d	(distance p1 p2)
		  slp (/ (- z2 z1) d)
		  )
	(setq s1 "XY plane"
		  d (distance p1 p2)
		  slp (/ (- y2 y1) d)
		  )
	)
  (setq slp (* slp 100.0))
  ; report
  (getstring (strcat "\nDE HELLING IS " (rtos slp 2 2) "% in "s1)))
  (setq *error* olderr)
  (princ)
  )
