;;    (ql-get)
;;      Returns an association list containing the current QLEADER
;;      settings from the Named Object Dictionary.
;;
;;    (ql-get<alist>)
;;      Sets the specified values for QLEADER settings from the given
;;      association list.  Returns an association list containing the
;;      new values.
;;
;;  These functions can be used to examine the current QLEADER ;;  settings, or to initialize the setting before using the QLEADER ;
;;  command.  For example, to use splined leaders and framed text:
;;
;;    (ql-set '((65 . 1)(72 . 1)))
;;
;;  Both functions use the following group codes to identify QLEADER ;;  settings:
;;
;;     3: user arrowhead block name (default="")
;;    40: default text width (default=0.0)
;;    60: annotation type (default=0)
;;        0=MText
;;        1=copy object
;;        2=Tolerance
;;        3=block
;;        4=none
;;    61: annotation reuse (default=0)
;;        0=none
;;        1=reuse next
;;    62: left attachment point (default=1)
;;    63: right attachment point (default=3)
;;        0=Top of top line
;;        1=Middle of top line
;;        2=Middle of multiline text
;;        3=Middle of bottom line
;;        4=Bottom of bottom line
;;    64: underline bottom line (default=0)
;;    65: use splined leader line (default=0)
;;    66: no limit on points (default=0)
;;    67: maximum number of points (default=3)
;;    68: prompt for MText width (word wrap) (default=1)
;;    69: always left justify (default=0)
;;    70: allowed angle, first segment (default=0)
;;    71: allowed angle, second segment (default=0)
;;        0=Any angle
;;        1=Horizontal
;;        2=90deg
;;        3=45deg
;;        4=30deg
;;        5=15deg
;;    72: frame text (default=0)
;;   170: active tab (default=0)
;;        0=Annotation
;;        1=Leader Line&  Arrow
;;        2=Attachment
;;   340: object ID for annotation reuse

(DEFUN *ERROR* (MSG)
   (PRINC)
)

(DEFUN QL-GET (/ XR COD ITM REPLY)
   (IF (SETQ XR (DICTSEARCH (NAMEDOBJDICT) "AcadDim"))
     (PROGN
       (FOREACH COD
	       '(3 40 60 61 62 63 64 65 66 67 68 69 70 71 72 170 340)
	(IF (SETQ ITM (ASSOC COD XR))
	  (SETQ REPLY (APPEND REPLY (LIST ITM)))
	)
       )
       REPLY
     )
     '((3 . "")
       (40 . 0.0)
       (60 . 0)
       (61 . 0)
       (62 . 1)
       (63 . 1)
       (64 . 0)
       (65 . 1)
       (66 . 0)
       (67 . 3)
       (68 . 0)
       (69 . 0)
       (70 . 0)
       (71 . 0)
       (72 . 0)
       (170 . 0)
      )
   )
)

(DEFUN QL-SET (ARG / CUR PRM)
   (SETQ CUR (QL-GET))
   (WHILE ARG
     (SETQ PRM (CAR ARG)
	  ARG (CDR ARG)
	  CUR (SUBST PRM (ASSOC (CAR PRM) CUR) CUR)
     )
     (IF	(= 3 (CAR PRM))
       (SETVAR "DIMLDRBLK" (CDR PRM))
     )
   )
   (DICTREMOVE (NAMEDOBJDICT) "AcadDim")
   (SETQ
     CUR	(APPEND	'((0 . "XRECORD") (100 . "AcDbXrecord") (90 . 990106))
		CUR
	)
   )
   (DICTADD (NAMEDOBJDICT) "ACADDIM" (ENTMAKEX CUR))
   (QL-GET)
)

(DEFUN c:qlsettings (/		 ANNOTYPE    TXTWIDTH	 MTXTWDTH
		     LJUSTIFY	 FRAMETXT    LATTPNT	 RATTPNT
		     UBOTTOM	 ANNREUSE    USESPLIN	 MAXNMPNT
		     NOLIMPNT	 ABLKNAME    FANGLE	 SANGLE
		    )
   (INITGET "Mtext Copy Tolerance Block None _0 1 2 3 4")
   (SETQ	ANNOTYPE
	 (GETKWORD
	   "\nAnnotation type [Mtext/Copy object/Tolerance/Block/None]<Mtext>: "
	 )
   )
   (IF (= ANNOTYPE NIL)
     (SETQ ANNOTYPE "0")
   )
   (IF (= ANNOTYPE "0")
     (PROGN
       (INITGET "No Yes _0 1")
       (SETQ TXTWIDTH (GETKWORD
		       "\nPrompt for MText width [Yes/No]<Yes>: "
		     )
       )
       (IF (= TXTWIDTH NIL)
	(SETQ TXTWIDTH "1")
       )
       (IF (= TXTWIDTH "1")
	(PROGN
	  (INITGET 4)
	  (SETQ	MTXTWDTH
		 (GETREAL
		   (STRCAT "\nDefault text width<"
			   (RTOS 0.0 (GETVAR "LUNITS") (GETVAR "LUPREC"))
			   ">: "
		   )
		 )
	  )
	)
       )
       (IF (= MTXTWDTH NIL)
	(SETQ MTXTWDTH 0.0)
       )
       (INITGET "No Yes _0 1")
       (SETQ
	LJUSTIFY (GETKWORD "\nAlways left justify [Yes/No]<No>: ")
       )
       (IF (= LJUSTIFY NIL)
	(SETQ LJUSTIFY "0")
       )
       (INITGET "No Yes _0 1")
       (SETQ FRAMETXT (GETKWORD "\nFrame text [Yes/No]<No>: "))
       (IF (= FRAMETXT NIL)
	(SETQ FRAMETXT "0")
       )
       (INITGET "TT MT MM MB BB _0 1 2 3 4")
       (SETQ
	LATTPNT	(GETKWORD
		  "\nLeft attachment point [TT/MT/MM/MB/BB]<MT>: "
		)
       )
       (IF (= LATTPNT NIL)
	(SETQ LATTPNT "1")
       )
       (INITGET "TT MT MM MB BB _0 1 2 3 4")
       (SETQ
	RATTPNT	(GETKWORD
		  "\nRight attachment point [TT/MT/MM/MB/BB]<MM>: "
		)
       )
       (IF (= RATTPNT NIL)
	(SETQ RATTPNT "3")
       )
       (INITGET "No Yes _0 1")
       (SETQ UBOTTOM
	     (GETKWORD "\nUnderline bottom line [Yes/No]<No>: ")
       )
       (IF (= UBOTTOM NIL)
	(SETQ UBOTTOM "0")
       )
     )
   )
   (INITGET "None Reuse _0 1")
   (SETQ	ANNREUSE
	 (GETKWORD "\nAnnotation reuse [None/Reuse next]<None>: "
	 )
   )
   (IF (= ANNREUSE NIL)
     (SETQ ANNREUSE "0")
   )
   (INITGET "No Yes _0 1")
   (SETQ USESPLIN (GETKWORD "\nUse splined leader [Yes/No]<No>: "))
   (IF (= USESPLIN NIL)
     (SETQ USESPLIN "0")
   )
   (INITGET 6)
   (SETQ
     MAXNMPNT (GETINT "\nNumber of points or<Enter>  for no limit: ")
   )
   (IF (= MAXNMPNT NIL)
     (PROGN
       (SETQ MAXNMPNT "2")
       (SETQ NOLIMPNT "1")
     )
   )
   (SETQ	ABLKNAME
	 (GETKWORD
	   "\nUser arrowhead block name or<Enter>  for none: "
	 )
   )
   (IF (= ABLKNAME NIL)
     (SETQ ABLKNAME "")
   )
   (INITGET "Any Horizontal 90 45 30 15 _0 1 2 3 4 5")
   (SETQ	FANGLE
	 (GETKWORD
	   "\nFirst segment angle constraint [Any angle/Horizontal/90/45/30/15]<Any>: "
	 )
   )
   (IF (= FANGLE NIL)
     (SETQ FANGLE "0")
   )
   (INITGET "Any Horizontal 90 45 30 15 _0 1 2 3 4 5")
   (SETQ	SANGLE
	 (GETKWORD
	   "\nSecond segment angle constraint [Any angle/Horizontal/90/45/30/15]<Any>: "
	 )
   )
   (IF (= SANGLE NIL)
     (SETQ SANGLE "0")
   )
   (QL-SET
     (LIST (CONS 3 ABLKNAME)
	  (CONS 40 MTXTWDTH)
	  (CONS 60 (ATOI ANNOTYPE))
	  (CONS 61 (ATOI ANNREUSE))
	  (CONS 62 (ATOI LATTPNT))
	  (CONS 63 (ATOI RATTPNT))
	  (CONS 64 (ATOI UBOTTOM))
	  (CONS 65 (ATOI USESPLIN))
	  (CONS 66 (ATOI NOLIMPNT))
	  (CONS 67 (ATOI MAXNMPNT))
	  (CONS 68 (ATOI TXTWIDTH))
	  (CONS 69 (ATOI LJUSTIFY))
	  (CONS 70 (ATOI FANGLE))
	  (CONS 71 (ATOI SANGLE))
	  (CONS 72 (ATOI FRAMETXT))
	  (CONS 170 0)
     )
   )
   (PRINC)
)
