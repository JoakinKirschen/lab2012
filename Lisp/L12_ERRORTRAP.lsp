;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_ERRORTRAP ()
(princ "L12_ERRORTRAP is loaded")
(princ)
)

(defun error()						;load function
(prompt "\nGlobal Error Trap Loaded")			;inform user
(princ)
);defun
;;;*==========================================================
(defun initerr ()					;init error
  (setq oldlayer (getvar "clayer"))			;save settings
  (setq oldsnap (getvar "osmode"))
  (setq oldpick (getvar "pickbox"))
  (setq temperr *error*)				;save *error*
  (setq *error* trap)					;reassign *error*
  (princ)
);defun
;;;*===========================================================
(defun trap (errmsg)					;define trap
;  (command nil nil nil)
  (if (not (member errmsg '("console break" "Function Cancelled"))
      )
    (princ (strcat "\nError: " errmsg))			;print message
  )                 
; (command "undo" "b")					;undo back
  (setvar "clayer" oldlayer)				;reset settings
  (setvar "blipmode" 0)
  (setvar "menuecho" 0)
  (setvar "cmdecho" 1)
  (setvar "highlight" 1)
  (setvar "luprec" 2)
  (setvar "osmode" oldsnap)
  (setvar "pickbox" oldpick)
;  (princ "\nError Resetting Enviroment ")		;inform user
  (terpri)
  (setq *error* temperr)				;restore *error*
  (princ)
);defun
;;;*===========================================================
(defun reset ()						;define reset
  (setq *error* temperr)				;restore *error*
  (setvar "clayer" oldlayer)				;reset settings
  (setvar "blipmode" 0)
  (setvar "menuecho" 0)
  (setvar "cmdecho" 1)
  (setvar "highlight" 1)
  (setvar "luprec" 2)
  (setvar "osmode" oldsnap)
  (setvar "pickbox" oldpick)
  (princ)
);defun
;;;*======================================================
(princ)