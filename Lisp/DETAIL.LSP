
(DEFUN C:Detail	(/	  INF	   PNT	    RADIUS   SSET     NAM
		 CIRCEL	  CNT	   ANG	    S_DLFAC  SclFact  TRIMPNT
		 CPT	  TrimDst  V9	    TrimPos  LastEnt
		)

  (DEFUN SelectAfter (LastEnt / NAM SSET)
    (setq SSET (SSADD))
    (setq NAM (entnext LastEnt))
    (while NAM
      (setq SSET (SSADD NAM SSET))
      (setq NAM (entnext NAM))
    )
    SSET
  )
  (DEFUN ExplodeComplex	(SSET / CNT NAM INF LastEnt)
    (setq LastEnt (ENTLAST))
    (setq CNT 0)
    (setq NAM (SSNAME SSET CNT))
    (while NAM
      (setq INF (entget NAM))
      (if (OR (= (cdr (assoc 0 INF)) "INSERT")
	  )
	(command ".EXPLODE" NAM)
      )
      (setq CNT (1+ CNT))
      (setq NAM (SSNAME SSET CNT))
    )
    (princ)
  )
  (DEFUN TRIMPNT (PNT SSET / CNT)
    (SETQ CNT 0)
    (REPEAT (SSLENGTH SSET)
      (COMMAND (LIST (SSNAME SSET CNT) PNT))
      (SETQ CNT (1+ CNT))
    )
  )
 (setq cmd (getvar "cmdecho" ))  (setvar "cmdecho" 0)
  (command ".Undo" "Group")
  (SETQ CPT (GETPOINT "\nIndicate Detail Center : "))
  (IF CPT
    (progn
      (COMMAND "circle" CPT PAUSE)
      (COMMAND "chprop" (ENTLAST) "" "color" 3 "")
      (SETQ SclFact (GETREAL "\nEnter scale factor: ")
	    INF	    (ENTGET (ENTLAST))
	    ANG	    0.0
	    PNT1    (TRANS (CDR (ASSOC 10 INF)) (CDR (ASSOC -1 INF)) 1)
	    RADIUS  (cdr (assoc 40 INF))
	    V9	    (* SclFact RADIUS (/ (* 2 PI) 48.0))
	    TrimDst (+ (* SclFact RADIUS) (* 1.02 V9))
	    S_DLFAC (GETVAR "DIMLFAC")
	    SSET    (SSGET "C"
			   (POLAR PNT1 (/ PI 4) (* 1.415 RADIUS))
			   (POLAR PNT1 (- (* (/ PI 4) 3)) (* 1.415 RADIUS))
		    )
      )
      (SETVAR "DIMLFAC" (/ 1.0 SclFact))
      (COMMAND "circle"
	       PNT1
	       (* SclFact RADIUS)
	       "chprop"
	       (ENTLAST)
	       ""
	       "color"
	       3
	       ""
      )
      (PROMPT "\nLocation for detail: ")
      (COMMAND "move" (SETQ CIRCEL (ENTLAST)) "" PNT1 PAUSE)
      (SETQ PNT2 (TRANS	(CDR (ASSOC 10 (ENTGET (ENTLAST))))
			(CDR (ASSOC -1 (ENTGET (ENTLAST))))
			1
		 )
      )
      (entmake
	(LIST '(0 . "LINE")
	      '(62 . 3)
	      (Cons 10 (POLAR PNT1 (ANGLE PNT1 PNT2) RADIUS))
	      (Cons 11 (POLAR PNT2 (ANGLE PNT2 PNT1) (* RADIUS SclFact)))
	)
      )
      (setq LastEnt (ENTLAST))
      (COMMAND "copy" SSET "" PNT1 PNT1)
      (setq SSET (SelectAfter LastEnt))
      (ExplodeComplex SSET)
      (setq SSET (SelectAfter LastEnt))
      (COMMAND "move" SSET "" PNT1 PNT2	"redraw" "scale" SSET "" PNT2
	       SclFact)
      (COMMAND "trim" CIRCEL "")
      (REPEAT 48
	(SETQ TrimPos (POLAR PNT2 ANG TrimDst)
	      SSET    (SSGET "C"
			     (POLAR TrimPos (/ PI 4) V9)
			     (POLAR TrimPos (- (* (/ PI 4) 3)) V9)
		      )
	)
	(COND (SSET (TRIMPNT TrimPos SSET)))
	(SETQ ANG (+ ANG (/ (* 2 PI) 48)))
      )
      (COMMAND "")
      (ENTDEL CIRCEL)
      (setq SSET (SelectAfter LastEnt))
      (setq ANG 0.0)
      (command "erase" SSET "R" "All")
      (REPEAT 48
	(SETQ TrimPos (POLAR PNT2 ANG TrimDst))
	(SETQ ANG (+ ANG (/ (* 2 PI) 48)))
	(command TrimPos)
      )
      (COMMAND "" "")
      (REDRAW)
      (SETVAR "DIMLFAC" S_DLFAC)
    )
  )
  (command "Undo" "End")
  T
)
(PRINT)
