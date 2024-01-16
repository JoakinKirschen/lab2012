;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_EXCEL ()
(princ "L12_EXCEL is loaded")
(princ)
)

; made by JOKI aka kiteksoft HIhi nobody will read this lol 

(defun c:Buigs (/	   fp	      lst	 excelfile  tekstfile
		2dlist	   $aanduid   $aantpel	 $diam	    $wapkwali
		$tlengte   $aantel    $totlengte $elmntnm   2dlist
		row	   check1     check2	 start	    program
		mark	   runner     kilos	 program  info  t1 t2 t3 titleblock
		total	   count6     count8	 count10    count12
		count14	   count16    count18	 count20    count25
		count28	   count32    count36	 count40 
	       )
  (initerr)
  (setvar "cmdecho" 0)
  (initget "Yes No")
  (setq info (getkword "Select a GMI titleblock? (Yes or No) "))
  (if (= info nil) (setq info "n")())
  (if (= info "Yes")
	(setq titleblock (L12_readblock))
  )
  (setq excelfile (getfiled "Save As" "c:/" "xls" 1))
  (if (= excelfile nil) (exit))
  (vl-file-delete excelfile)
  (vl-file-copy
    (strcat LabPathDest "\\Buigstaat.xls")
    excelfile
  )
  
  (setq tekstfile (strcat (getenv "Temp") "\\Buigstaat.txt"))
  
  (if (findfile tekstfile)
  (vl-file-delete tekstfile)
  )
  
  (command "-attext"
	   "E"
	   "all"
	   ""
	   "sdf"
	   (findfile "BuigstaatTemplate.txt")
	   tekstfile
  )

  (setq fp (open tekstfile "r"))
  (while (setq l (read-line fp))
     (setq lst (cons l lst))
  )
  (close fp)
	
  (if (= (length lst) 0)
    (progn
      (alert "No reinforcement found.\nPlease check if ur in the right space.")
      (exit)
    )
  )
  
  (setq lst (reverse lst))

  (setq 2dlist ())
  (foreach a lst
    (setq $aanduid (trim (substr a 1 6)))
    (setq $aantpel (read (substr a 7 3)))
    (setq $diam (read (substr a 10 2)))
;    (setq $wapkwali (read (substr a 12 5)))
    (setq $tlengte (read (substr a 17 7)))
    (setq $aantel (read (substr a 24 3)))
;    (setq $totlengte (read (substr a 27 8)))
    (setq $elmntnm (trim (substr a 35 20))) ;ok
    (setq 2dlist (cons (list $diam	  $elmntnm     $aantel
			     $aanduid	  $aantpel     $tlengte
			    )
		       2dlist
		 )
    )
  )
  (setq check1 (length 2dlist))
  (setq	2dlist 
		  (vl-sort	2dlist
			(function (lambda (e1 e2)
				    (< (car e1) (car e2))
				  )
			)
	       )
  )
  (setq check2 (length 2dlist))
  (if (/= check1 check2)
    (progn
      (alert "Something went wrong sorting the lists")
      (exit)
    )
  )
  (setq row 13)				;startrow
  (setq start 0)
  (setq mark nil)
  (setq count6 0)
  (setq count8 0)
  (setq count10 0)
  (setq count12 0)
  (setq count14 0)
  (setq count16 0)
  (setq count18 0)
  (setq count20 0)
  (setq count25 0)
  (setq count28 0)
  (setq count32 0)
  (setq count36 0)
  (setq count40 0)


  (OpenExcel excelfile "Blad1" T)
  (if (= info "Yes")
  (progn
  (if (setq t1 (vl-princ-to-string(nth 0 titleblock))) (progn (PutCell "C5" t1)))
  (if (setq t2 (vl-princ-to-string(nth 1 titleblock))) (progn (PutCell "C6" t2)))
  (if (setq t3 (vl-princ-to-string(nth 6 titleblock))) (progn (PutCell "C7"  (substr t3 1 7)) (PutCell "C8" t3) (PutCell "G5" (substr t3 1 11))))
  )
  )
  
  (PutCell "G6" "0")
  (PutCell "G7" (L12_getdate))
  (foreach a 2dlist

    (if	(/= (nth 0 a) start)		;als diameter wijzigt
      (progn
	(if (/= mark nil)
	  (progn
	    (PutCell
	      (strcat "G" (itoa row))
	      (list
		"TOTAAL"
		(strcat "=sum(H" (itoa mark) ":H" (itoa (- row 1)) ")")
	      )
	    )
		(FatCell "G" row)(FatCell "H" row)
					;(ExLine "G" row (list 0 0 1 0))
					;(ExLine "H" row (list 0 0 1 0))
	   ; (ExRowHeight row 15)
	    (setq row (+ row 1))
	  )
	)
	(PutCell (strcat "B" (itoa row))
		 (list "Diameter" (itoa (nth 0 a)))
	)
	(ExRowHeight row 20.0)
	(setq row (+ row 1))
	(PutCell (strcat "B" (itoa row))
		 (list "Elementnaam" ""	"Aantal" "Aanduid" "#/El" "Tlengte" "Totlengte" )
	)
	(ExLine "B" row (list 0 0 1 1))
	(ExLine "C" row (list 0 0 1 1))
	(ExLine "D" row (list 0 0 1 1))
	(ExLine "E" row (list 0 0 1 1))
	(ExLine "F" row (list 0 0 1 1))
	(ExLine "G" row (list 0 0 1 1))
	(ExLine "H" row (list 0 0 1 1))
	(ExRowHeight row 20.0)
	(setq row (+ row 1))
	(setq start (nth 0 a))
	(setq mark row)
	(setq runner 1)
      )
    )
    (PutCell (strcat "B" (itoa row))
	     (vl-princ-to-string (nth 1 a))
    )
    (PutCell (strcat "D" (itoa row))
	     (vl-princ-to-string (nth 2 a))
    )
    (PutCell (strcat "E" (itoa row))
	     (vl-princ-to-string (nth 3 a))
    )
    (PutCell (strcat "F" (itoa row))
	     (vl-princ-to-string (nth 4 a))
    )
    (PutCell (strcat "G" (itoa row))
	     (vl-princ-to-string (nth 5 a))
    )
    (PutCell (strcat "H" (itoa row))
	     (strcat "=D" (itoa row) "*F" (itoa row) "*G" (itoa row))
    )
    (setq kilos	(/ (* (nth 0 a)
		      (nth 0 a)
		      (nth 2 a)
		      (nth 4 a)
		      (nth 5 a)
		      3.14159
		      7850
		   )
		   4000000000
		)
    )
    (setq row (+ row 1))
    (Cond
      ((= (nth 0 a) 6)
       (setq count6 (+ count6 kilos))
      )
      ((= (nth 0 a) 8)
       (setq count8 (+ count8 kilos))
      )
      ((= (nth 0 a) 10)
       (setq count10 (+ count10 kilos))
      )
      ((= (nth 0 a) 12)
       (setq count12 (+ count12 kilos))
      )
      ((= (nth 0 a) 14)
       (setq count14 (+ count14 kilos))
      )
      ((= (nth 0 a) 16)
       (setq count16 (+ count16 kilos))
      )
      ((= (nth 0 a) 18)
       (setq count18 (+ count18 kilos))
      )
      ((= (nth 0 a) 20)
       (setq count20 (+ count20 kilos))
      )
      ((= (nth 0 a) 25)
       (setq count25 (+ count25 kilos))
      )
      ((= (nth 0 a) 28)
       (setq count28 (+ count28 kilos))
      )
      ((= (nth 0 a) 32)
       (setq count32 (+ count32 kilos))
      )
      ((= (nth 0 a) 36)
       (setq count36 (+ count36 kilos))
      )
      ((= (nth 0 a) 40)
       (setq count40 (+ count40 kilos))
      )
    )
  )					;end foreach

  (setq	total (+ count6	    count8     count10	  count12    count14
		 count16    count18    count20	  count25    count28
		 count32    count36    count40
		)
  )

  (progn
    (PutCell
      (strcat "G" (itoa row))
      (list "TOTAAL"
	    (strcat "=sum(H" (itoa mark) ":H" (itoa (- row 1)) ")")
      )
    )
    (FatCell "G" row)(FatCell "H" row)
					;(ExLine "G" row (list 0 0 1 0))
					;(ExLine "H" row (list 0 0 1 0))
    (setq row (+ row 1))
  )
  (PutCell (strcat "B" (itoa row)) "Samenvatting Gewichten:")
  (ExRowHeight row 15)
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "diam.6:"
		 (strcat (rtos count6 2 1) " kg")
		 ""
		 ""
		 "diam.20:"
		 (strcat (rtos count20 2 1) " kg")
		 ""
	   )
  )
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "diam.8:"
		 (strcat (rtos count8 2 1) " kg")
		 ""
		 ""
		 "diam.25:"
		 (strcat (rtos count25 2 1) " kg")
		 ""
	   )
  )
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "diam.10:"
		 (strcat (rtos count10 2 1) " kg")
		 ""
		 ""
		 "diam.28:"
		 (strcat (rtos count28 2 1) " kg")
		 ""
	   )
  )
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "diam.12:"
		 (strcat (rtos count12 2 1) " kg")
		 ""
		 ""
		 "diam.32:"
		 (strcat (rtos count32 2 1) " kg")
		 ""
	   )
  )
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "diam.14:"
		 (strcat (rtos count14 2 1) " kg")
		 ""
		 ""
		 "diam.36:"
		 (strcat (rtos count36 2 1) " kg")
		 ""
	   )
  )
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "diam.16:"
		 (strcat (rtos count16 2 1) " kg")
		 ""
		 ""
		 "diam.40:"
		 (strcat (rtos count40 2 1) " kg")
		 ""
	   )
  )
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "diam.18:" (strcat (rtos count18 2 1) " kg"))
  )
  (setq row (+ row 1))
  (ExRowHeight row 5)
  (setq row (+ row 1))
  (PutCell (strcat "B" (itoa row))
	   (list "Totaal:" (strcat (rtos total 2 1) " kg"))
  )
  (ExRowHeight row 20)
  (ExLine "B" row (list 0 0 1 0))
  (ExLine "C" row (list 0 0 1 0))
  (ExLine "D" row (list 0 0 1 0))
  (ExLine "E" row (list 0 0 1 0))
  (ExLine "F" row (list 0 0 1 0))
  (ExLine "G" row (list 0 0 1 0))
  (ExLine "H" row (list 0 0 1 0))
  (CloseExcel2 excelfile)
  ;(setq program (getenv "L12_ExcelPath"))
  ;(startapp program excelfile)
  (reset)
  (princ)
					;(qsort 2dlist)
					;(princ 2dlist)

)


;-------------------------------------------------------------------------------
; StyleRow - Styles a row
; Arguments: ?
;   StartCell$ = Starting Cell ID
;   Data@ = Value or list of values
; Syntax examples:
; (PutCell "A1" "PART NUMBER") = Puts PART NUMBER in cell A1
; (PutCell "B3" '("Dim" 7.5 "9.75")) = Starting with cell B3 put Dim, 7.5, and 9.75 across
;-------------------------------------------------------------------------------

(defun ExRowHeight (rownr$ height / Rang)
(setq Rang (vlax-variant-value(vlax-get-property (vlax-get-property *ExcelApp% "Rows") "Item" rownr$)))
(vlax-put-property Rang "RowHeight" (vlax-make-variant height 3)); 25.0 is new row height, 3 is variant type 
(vlax-put-property Rang "Verticalalignment" (vlax-make-variant -4108 3))
(setq Fonto (vlax-get-property Rang "Font"))
(vlax-put-property Fonto "Size" (vlax-make-variant 10 5))
(vlax-put-property Fonto "Bold" (vlax-make-variant 1 11))
;(vlax-put-property Rang "Horizontalalignment" (vlax-make-variant -4108 3))
;(vlax-put-property (vlax-get-property Rang "Interior")
;"Colorindex" (vlax-make-variant 4))
;;working with borders :
;(setq Bord (vlax-get-property Rang "Borders"))
;(vlax-put-property Bord "Color" (vlax-make-variant -1 3)) ; borders off
;(vlax-put-property Bord "Color" (vlax-make-variant 1 3)) ;borders on
;; border lines (thin)
;(vlax-put-property Bord "LineStyle" (vlax-make-variant 1 3))
;; borders color
;(vlax-put-property Bord "Colorindex" (vlax-make-variant 5))
;;working with font :
;(setq Fonto (vlax-get-property Rang "Font"))
;(vlax-put-property Fonto "Name" (vlax-make-variant "Times New Roman" 12))
;(vlax-put-property Fonto "Size" (vlax-make-variant 12 5))
;(vlax-put-property Fonto "Bold" (vlax-make-variant 1 11))
;(vlax-put-property Fonto "Italic" (vlax-make-variant 1 11))
;(vlax-put-property Fonto "Colorindex" (vlax-make-variant 5));ETC
)

(defun ExLine (coltxt$ rownr$ lines / Rang R1 C1 Cel Sel Bords cnt)
(setq Rang (vlax-variant-value(vlax-get-property (vlax-get-property *ExcelApp% "Rows") "Item" rownr$)))
;(vlax-invoke-method Rang "Activate");optional
(setq LL (nth 0 lines))
(setq RL (nth 1 lines))
(setq TL (nth 2 lines))
(setq BL (nth 3 lines))
(setq Cels (vlax-get-property Rang "Cells"))
(setq R1 1)
(setq C1 (Alpha2Number coltxt$))
(setq Cel (vlax-variant-value
(vlax-get-property Cels "Item"(vlax-make-variant R1)(vlax-make-variant C1))))
(vlax-invoke-method Cel "Select")
(setq Sel (vlax-get-property *ExcelApp% "Selection"))
(setq Bords (vlax-get-property Sel "Borders"))
(setq cnt 0)
(vlax-for a Bords (setq cnt (1+ cnt))
(vl-catch-all-apply (function (lambda()
(progn 
(if (< cnt 5)  ;bepaald waar de lijnen moeten worden toegepast
(progn
(if (and(= cnt 1)(= LL 1))
(progn 
(vlax-put-property a "LineStyle"(vlax-make-variant 1 3)) ; 2de cijfer 3=volle lijn 1=dashdot
(vlax-put-property a "Weight"(vlax-make-variant 2 3)) ;1ste cijfer 1=puntjes 2=Fijn 3=Dik 2de cijfer
;(vlax-put-property a "ColorIndex"(vlax-make-variant 1 5))
)
)
(if (and(= cnt 2)(= RL 1))
(progn 
(vlax-put-property a "LineStyle"(vlax-make-variant 1 3)) ; 2de cijfer 3=volle lijn 1=dashdot
(vlax-put-property a "Weight"(vlax-make-variant 2 3)) ;1ste cijfer 1=puntjes 2=Fijn 3=Dik 2de cijfer
;(vlax-put-property a "ColorIndex"(vlax-make-variant 1 5))
)
)
(if (and(= cnt 3)(= TL 1))
(progn 
(vlax-put-property a "LineStyle"(vlax-make-variant 1 3)) ; 2de cijfer 3=volle lijn 1=dashdot
(vlax-put-property a "Weight"(vlax-make-variant 2 3)) ;1ste cijfer 1=puntjes 2=Fijn 3=Dik 2de cijfer
;(vlax-put-property a "ColorIndex"(vlax-make-variant 1 5))
)
)
(if (and(= cnt 4)(= BL 1))
(progn 
(vlax-put-property a "LineStyle"(vlax-make-variant 1 3)) ; 2de cijfer 3=volle lijn 1=dashdot
(vlax-put-property a "Weight"(vlax-make-variant 2 3)) ;1ste cijfer 1=puntjes 2=Fijn 3=Dik 2de cijfer
;(vlax-put-property a "ColorIndex"(vlax-make-variant 1 5))
)
))
;progn
;; turn off the diagonal lines:
(vlax-put-property a "LineStyle" (vlax-make-variant -4142 3))))))))
)

(defun FatCell (coltxt$ rownr$ / Rang R1 C1 Cel Sel Bords cnt)
(setq Rang (vlax-variant-value(vlax-get-property (vlax-get-property *ExcelApp% "Rows") "Item" rownr$)))
;(vlax-invoke-method Rang "Activate");optional
(setq Cels (vlax-get-property Rang "Cells"))
(setq R1 1)
(setq C1 (Alpha2Number coltxt$))
(setq Cel (vlax-variant-value
(vlax-get-property Cels "Item"
;; row number :
(vlax-make-variant R1)
;; column number :
(vlax-make-variant C1))))
(vlax-invoke-method Cel "Select")
;; get application selection: 
(setq Sel (vlax-get-property *ExcelApp% "Selection"))
(setq Fonto (vlax-get-property Sel "Font"))
;(vlax-put-property Fonto "Size" (vlax-make-variant 10 5))
(vlax-put-property Fonto "Bold" (vlax-make-variant 1 11))
)

(defun StyleCell (coltxt$ rownr$ / Rang R1 C1 Cel Sel Bords cnt)
(setq Rang (vlax-variant-value(vlax-get-property (vlax-get-property *ExcelApp% "Rows") "Item" rownr$)))
;(vlax-invoke-method Rang "Activate");optional

(setq Cels (vlax-get-property Rang "Cells"))
(setq R1 1)
(setq C1 (Alpha2Number coltxt$))
(setq Cel (vlax-variant-value
(vlax-get-property Cels "Item"
;; row number :
(vlax-make-variant R1)
;; column number :
(vlax-make-variant C1))))

;(vlax-put-property Cel "Value2" (vlax-make-variant "First Cell in Range" 12))
;; Set interior color :
;(vlax-put-property (vlax-get-property Cel "Interior")"Colorindex" (vlax-make-variant 28))
;; select the particular cell:
(vlax-invoke-method Cel "Select")
;; get application selection: 
(setq Sel (vlax-get-property *ExcelApp% "Selection"))
;; get selection borders
(setq Bords (vlax-get-property Sel "Borders"))
;; iterate through all edges of selection
(setq cnt 0)
(vlax-for a Bords (setq cnt (1+ cnt))
(vl-catch-all-apply (function (lambda()
(progn 
(if (< cnt 5)  ;bepaald waar de lijnen moeten worden toegepast
(progn 
(vlax-put-property a "LineStyle"(vlax-make-variant 1 3)) ; 2de cijfer 3=volle lijn 1=dashdot
(vlax-put-property a "Weight"(vlax-make-variant 2 3)) ;1ste cijfer 1=puntjes 2=Fijn 3=Dik 2de cijfer
;(vlax-put-property a "ColorIndex"(vlax-make-variant 1 5))
)
;progn
;; turn off the diagonal lines:
(vlax-put-property a "LineStyle" (vlax-make-variant -4142 3))))))))
;; Horizontal alignment Center :
(vlax-put-property Cel "Horizontalalignment" (vlax-make-variant -4108 3))
;; Vertical alignment Bottom :
(vlax-put-property Cel "VerticalAlignment" (vlax-make-variant -4107 3))
;; Set number format :
(vlax-put-property Cel "NumberFormat" (vlax-make-variant "0,00" 8))
)
;-------------------------------------------------------------------------------
; Program Name: GetExcel.lsp [GetExcel R4]
; Created By:   Terry Miller (Email: terrycadd@yahoo.com)
;               (URL: http://web2.airmail.net/terrycad)
; Date Created: 9-20-03
; Function:     Several functions to get and put values into Excel cells.
;-------------------------------------------------------------------------------
; Revision History
; Rev  By     Date    Description
;-------------------------------------------------------------------------------
; 1    TM   9-20-03   Initial version
; 2    TM   8-20-07   Rewrote GetExcel.lsp and added several new sub-functions
;                     including ColumnRow, Alpha2Number and Number2Alpha written
;                     by Gilles Chanteau from Marseille, France.
; 3    TM   12-1-07   Added several sub-functions written by Gilles Chanteau
;                     including Cell-p, Row+n, and Column+n. Also added his
;                     revision of the PutCell function.
; 4    GC   9-20-08   Revised the GetExcel argument MaxRange$ to accept a nil
;                     and get the current region from cell A1.
;-------------------------------------------------------------------------------
; Overview of Main functions
;-------------------------------------------------------------------------------
; GetExcel - Stores the values from an Excel spreadsheet into *ExcelData@ list
;   Syntax:  (GetExcel ExcelFile$ SheetName$ MaxRange$)
;   Example: (GetExcel "C:\\Folder\\Filename.xls" "Sheet1" "L30")
; GetCell - Returns the cell value from the *ExcelData@ list
;   Syntax:  (GetCell Cell$)
;   Example: (GetCell "H15")
; Function example of usage:
; (defun c:Get-Example ()
;   (GetExcel "C:\\Folder\\Filename.xls" "Sheet1" "L30");<-- Edit Filename.xls
;   (GetCell "H21");Or you can just use the global *ExcelData@ list
; );defun
;-------------------------------------------------------------------------------
; OpenExcel - Opens an Excel spreadsheet
;   Syntax:  (OpenExcel ExcelFile$ SheetName$ Visible)
;   Example: (OpenExcel "C:\\Folder\\Filename.xls" "Sheet1" nil)
; PutCell - Put values into Excel cells
;   Syntax:  (PutCell StartCell$ Data$) or (PutCell StartCell$ DataList@)
;   Example: (PutCell "A1" (list "GP093" 58.5 17 "Base" "3'-6 1/4\""))
; CloseExcel - Closes Excel session
;   Syntax:  (CloseExcel ExcelFile$)
;   Example: (CloseExcel "C:\\Folder\\Filename.xls")
; Function example of usage:
; (defun c:Put-Example ()
;   (OpenExcel "C:\\Folder\\Filename.xls" "Sheet1" nil);<-- Edit Filename.xls
;   (PutCell "A1" (list "GP093" 58.5 17 "Base" "3'-6 1/4\""));Repeat as required
;   (CloseExcel "C:\\Folder\\Filename.xls");<-- Edit Filename.xls
;   (princ)
; );defun
;-------------------------------------------------------------------------------
; Note: Review the conditions of each argument in the function headings
;-------------------------------------------------------------------------------
; GetExcel - Stores the values from an Excel spreadsheet into *ExcelData@ list
; Arguments: 3
;   ExcelFile$ = Path and filename
;   SheetName$ = Sheet name or nil for not specified
;   MaxRange$ = Maximum cell ID range to include or nil to get the current region from cell A1
; Syntax examples:
; (GetExcel "C:\\Temp\\Temp.xls" "Sheet1" "E19") = Open C:\Temp\Temp.xls on Sheet1 and read up to cell E19
; (GetExcel "C:\\Temp\\Temp.xls" nil "XYZ123") = Open C:\Temp\Temp.xls on current sheet and read up to cell XYZ123
;-------------------------------------------------------------------------------
(defun GetExcel (ExcelFile$ SheetName$ MaxRange$ / Column# ColumnRow@ Data@ ExcelRange^
  ExcelValue ExcelValue ExcelVariant^ MaxColumn# MaxRow# Range$ Row# Worksheet)
  (if (= (type ExcelFile$) 'STR)
    (if (not (findfile ExcelFile$))
      (progn
        (alert (strcat "Excel file " ExcelFile$ " not found."))
        (exit)
      );progn
    );if
    (progn
      (alert "Excel file not specified.")
      (exit)
    );progn
  );if
  (gc)
  (if (setq *ExcelApp% (vlax-get-object "Excel.Application"))
    (progn
      (alert "Close all Excel spreadsheets to continue!")
      (vlax-release-object *ExcelApp%)(gc)
    );progn
  );if
  (setq ExcelFile$ (findfile ExcelFile$))
  (setq *ExcelApp% (vlax-get-or-create-object "Excel.Application"))
  (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Open ExcelFile$)
  (if SheetName$
    (vlax-for Worksheet (vlax-get-property *ExcelApp% "Sheets")
      (if (= (vlax-get-property Worksheet "Name") SheetName$)
        (vlax-invoke-method Worksheet "Activate")
      );if
    );vlax-for
  );if
  (if MaxRange$
    (progn
      (setq ColumnRow@ (ColumnRow MaxRange$))
      (setq MaxColumn# (nth 0 ColumnRow@))
      (setq MaxRow# (nth 1 ColumnRow@))
    );progn
    (progn
      (setq CurRegion (vlax-get-property (vlax-get-property
        (vlax-get-property *ExcelApp% "ActiveSheet") "Range" "A1") "CurrentRegion")
      );setq
      (setq MaxRow# (vlax-get-property (vlax-get-property CurRegion "Rows") "Count"))
      (setq MaxColumn# (vlax-get-property (vlax-get-property CurRegion "Columns") "Count"))
    );progn
  );if
  (setq *ExcelData@ nil)
  (setq Row# 1)
  (repeat MaxRow#
    (setq Data@ nil)
    (setq Column# 1)
    (repeat MaxColumn#
      (setq Range$ (strcat (Number2Alpha Column#)(itoa Row#)))
      (setq ExcelRange^ (vlax-get-property *ExcelApp% "Range" Range$))
      (setq ExcelVariant^ (vlax-get-property ExcelRange^ 'Value))
      (setq ExcelValue (vlax-variant-value ExcelVariant^))
      (setq ExcelValue
        (cond
          ((= (type ExcelValue) 'INT) (itoa ExcelValue))
          ((= (type ExcelValue) 'REAL) (rtosr ExcelValue))
          ((= (type ExcelValue) 'STR) (vl-string-trim " " ExcelValue))
          ((/= (type ExcelValue) 'STR) "")
        );cond
      );setq
      (setq Data@ (append Data@ (list ExcelValue)))
      (setq Column# (1+ Column#))
    );repeat
    (setq *ExcelData@ (append *ExcelData@ (list Data@)))
    (setq Row# (1+ Row#))
  );repeat
  (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") 'Close :vlax-False)
  (vlax-invoke-method *ExcelApp% 'Quit)
  (vlax-release-object *ExcelApp%)(gc)
  (setq *ExcelApp% nil)
  *ExcelData@
);defun GetExcel
;-------------------------------------------------------------------------------
; GetCell - Returns the cell value from the *ExcelData@ list
; Arguments: 1
;   Cell$ = Cell ID
; Syntax example: (GetCell "E19") = value of cell E19
;-------------------------------------------------------------------------------
(defun GetCell (Cell$ / Column# ColumnRow@ Return Row#)
  (setq ColumnRow@ (ColumnRow Cell$))
  (setq Column# (1- (nth 0 ColumnRow@)))
  (setq Row# (1- (nth 1 ColumnRow@)))
  (setq Return "")
  (if *ExcelData@
    (if (and (>= (length *ExcelData@) Row#)(>= (length (nth 0 *ExcelData@)) Column#))
      (setq Return (nth Column# (nth Row# *ExcelData@)))
    );if
  );if
  Return
);defun GetCell
;-------------------------------------------------------------------------------
; OpenExcel - Opens an Excel spreadsheet
; Arguments: 3
;   ExcelFile$ = Excel filename or nil for new spreadsheet
;   SheetName$ = Sheet name or nil for not specified
;   Visible = t for visible or nil for hidden
; Syntax examples:
; (OpenExcel "C:\\Temp\\Temp.xls" "Sheet2" t) = Opens C:\Temp\Temp.xls on Sheet2 as visible session
; (OpenExcel "C:\\Temp\\Temp.xls" nil nil) = Opens C:\Temp\Temp.xls on current sheet as hidden session
; (OpenExcel nil "Parts List" nil) =  Opens a new spreadsheet and creates a Part List sheet as hidden session
;-------------------------------------------------------------------------------
(defun OpenExcel (ExcelFile$ SheetName$ Visible / Sheet$ Sheets@ Worksheet)
  (if (= (type ExcelFile$) 'STR)
    (if (findfile ExcelFile$)
      (setq *ExcelFile$ ExcelFile$)
      (progn
        (alert (strcat "Excel file " ExcelFile$ " not found."))
        (exit)
      );progn
    );if
    (setq *ExcelFile$ "")
  );if
  (gc)
  (if (setq *ExcelApp% (vlax-get-object "Excel.Application"))
    (progn
      (alert "Close all Excel spreadsheets to continue!")
      (vlax-release-object *ExcelApp%)(gc)
    );progn
  );if
  (setq *ExcelApp% (vlax-get-or-create-object "Excel.Application"))
  (if ExcelFile$
    (if (findfile ExcelFile$)
      (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Open ExcelFile$)
      (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Add)
    );if
    (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Add)
  );if
  (if Visible
    (vla-put-visible *ExcelApp% :vlax-true)
  );if
  (if (= (type SheetName$) 'STR)
    (progn
      (vlax-for Sheet$ (vlax-get-property *ExcelApp% "Sheets")
        (setq Sheets@ (append Sheets@ (list (vlax-get-property Sheet$ "Name"))))
      );vlax-for
      (if (member SheetName$ Sheets@)
        (vlax-for Worksheet (vlax-get-property *ExcelApp% "Sheets")
          (if (= (vlax-get-property Worksheet "Name") SheetName$)
            (vlax-invoke-method Worksheet "Activate")
          );if
        );vlax-for
        (vlax-put-property (vlax-invoke-method (vlax-get-property *ExcelApp% "Sheets") "Add") "Name" SheetName$)
      );if
    );progn
  );if
  (princ)
);defun OpenExcel
;-------------------------------------------------------------------------------
; PutCell - Put values into Excel cells
; Arguments: 2
;   StartCell$ = Starting Cell ID
;   Data@ = Value or list of values
; Syntax examples:
; (PutCell "A1" "PART NUMBER") = Puts PART NUMBER in cell A1
; (PutCell "B3" '("Dim" 7.5 "9.75")) = Starting with cell B3 put Dim, 7.5, and 9.75 across
;-------------------------------------------------------------------------------
(defun PutCell (StartCell$ Data@ / Cell$ Column# ExcelRange Row#)
  (if (= (type Data@) 'STR)
    (setq Data@ (list Data@))
  )
  (setq ExcelRange (vlax-get-property *ExcelApp% "Cells"))
  (if (Cell-p StartCell$)
    (setq Column# (car (ColumnRow StartCell$))
          Row# (cadr (ColumnRow StartCell$))
    );setq
    (if (vl-catch-all-error-p
          (setq Cell$ (vl-catch-all-apply 'vlax-get-property
            (list (vlax-get-property *ExcelApp% "ActiveSheet") "Range" StartCell$))
          );setq
        );vl-catch-all-error-p
        (alert (strcat "The cell ID \"" StartCell$ "\" is invalid."))
        (setq Column# (vlax-get-property Cell$ "Column")
              Row# (vlax-get-property Cell$ "Row")
        );setq
    );if
  );if
  (if (and Column# Row#)
    (foreach Item Data@
      (vlax-put-property ExcelRange "Item" Row# Column# (vl-princ-to-string Item))
      (setq Column# (1+ Column#))
    );foreach
  );if
  (princ)
);defun PutCell


;-------------------------------------------------------------------------------
; CloseExcel - Closes Excel spreadsheet
; Arguments: 1
;   ExcelFile$ = Excel saveas filename or nil to close without saving
; Syntax examples:
; (CloseExcel "C:\\Temp\\Temp.xls") = Saveas C:\Temp\Temp.xls and close
; (CloseExcel nil) = Close without saving
;-------------------------------------------------------------------------------
(defun CloseExcel (ExcelFile$ / Saveas)
  (if ExcelFile$
    (if (= (strcase ExcelFile$) (strcase *ExcelFile$))
      (if (findfile ExcelFile$)
        (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") "Save")
        (setq Saveas t)
      );if
      (if (findfile ExcelFile$)
        (progn
          (vl-file-delete (findfile ExcelFile$))
          (setq Saveas t)
        );progn
        (setq Saveas t)
      );if
    );if
  );if
  (if Saveas
    (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook")
      "SaveAs" ExcelFile$ -4143 "" "" :vlax-false :vlax-false nil
    );vlax-invoke-method
  );if
  (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") 'Close :vlax-False)
  (vlax-invoke-method *ExcelApp% 'Quit)
  (vlax-release-object *ExcelApp%)(gc)
  (setq *ExcelApp% nil *ExcelFile$ nil)
  (princ)
);defun CloseExcel

(defun CloseExcel2 (ExcelFile$ / Saveas)
  (if ExcelFile$
    (if (= (strcase ExcelFile$) (strcase *ExcelFile$))
      (if (findfile ExcelFile$)
        (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") "Save")
        (setq Saveas t)
      );if
      (if (findfile ExcelFile$)
        (progn
          (vl-file-delete (findfile ExcelFile$))
          (setq Saveas t)
        );progn
        (setq Saveas t)
      );if
    );if
  );if
  (if Saveas
    (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook")
      "SaveAs" ExcelFile$ -4143 "" "" :vlax-false :vlax-false nil
    );vlax-invoke-method
  );if
  ;(vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") 'Close :vlax-False)
  ;(vlax-invoke-method *ExcelApp% 'Quit)
  (vlax-release-object *ExcelApp%)(gc)
  (setq *ExcelApp% nil *ExcelFile$ nil)
  (princ)
);defun CloseExcel
;-------------------------------------------------------------------------------
; ColumnRow - Returns a list of the Column and Row number
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Cell$ = Cell ID
; Syntax example: (ColumnRow "ABC987") = '(731 987)
;-------------------------------------------------------------------------------
(defun ColumnRow (Cell$ / Column$ Char$ Row#)
  (setq Column$ "")
  (while (< 64 (ascii (setq Char$ (strcase (substr Cell$ 1 1)))) 91)
    (setq Column$ (strcat Column$ Char$)
          Cell$ (substr Cell$ 2)
    );setq
  );while
  (if (and (/= Column$ "") (numberp (setq Row# (read Cell$))))
    (list (Alpha2Number Column$) Row#)
    '(1 1);default to "A1" if there's a problem
  );if
);defun ColumnRow
;-------------------------------------------------------------------------------
; Alpha2Number - Converts Alpha string into Number
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Str$ = String to convert
; Syntax example: (Alpha2Number "ABC") = 731
;-------------------------------------------------------------------------------
(defun Alpha2Number (Str$ / Num#)
  (if (= 0 (setq Num# (strlen Str$)))
    0
    (+ (* (- (ascii (strcase (substr Str$ 1 1))) 64) (expt 26 (1- Num#)))
       (Alpha2Number (substr Str$ 2))
    );+
  );if
);defun Alpha2Number
;-------------------------------------------------------------------------------
; Number2Alpha - Converts Number into Alpha string
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Num# = Number to convert
; Syntax example: (Number2Alpha 731) = "ABC"
;-------------------------------------------------------------------------------
(defun Number2Alpha (Num# / Val#)
  (if (< Num# 27)
    (chr (+ 64 Num#))
    (if (= 0 (setq Val# (rem Num# 26)))
      (strcat (Number2Alpha (1- (/ Num# 26))) "Z")
      (strcat (Number2Alpha (/ Num# 26)) (chr (+ 64 Val#)))
    );if
  );if
);defun Number2Alpha
;-------------------------------------------------------------------------------
; Cell-p - Evaluates if the argument Cell$ is a valid cell ID
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Cell$ = String of the cell ID to evaluate
; Syntax examples: (Cell-p "B12") = t, (Cell-p "BT") = nil
;-------------------------------------------------------------------------------
(defun Cell-p (Cell$)
  (and (= (type Cell$) 'STR)
    (or (= (strcase Cell$) "A1")
      (not (equal (ColumnRow Cell$) '(1 1)))
    );or
  );and
);defun Cell-p
;-------------------------------------------------------------------------------
; Row+n - Returns the cell ID located a number of rows from cell
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 2
;   Cell$ = Starting cell ID
;   Num# = Number of rows from cell
; Syntax examples: (Row+n "B12" 3) = "B15", (Row+n "B12" -3) = "B9"
;-------------------------------------------------------------------------------
(defun Row+n (Cell$ Num#)
  (setq Cell$ (ColumnRow Cell$))
  (strcat (Number2Alpha (car Cell$)) (itoa (max 1 (+ (cadr Cell$) Num#))))
);defun Row+n
;-------------------------------------------------------------------------------
; Column+n - Returns the cell ID located a number of columns from cell
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 2
;   Cell$ = Starting cell ID
;   Num# = Number of columns from cell
; Syntax examples: (Column+n "B12" 3) = "E12", (Column+n "B12" -1) = "A12"
;-------------------------------------------------------------------------------
(defun Column+n (Cell$ Num#)
  (setq Cell$ (ColumnRow Cell$))
  (strcat (Number2Alpha (max 1 (+ (car Cell$) Num#))) (itoa (cadr Cell$)))
);defun Column+n
;-------------------------------------------------------------------------------
; rtosr - Used to change a real number into a short real number string
; stripping off all trailing 0's.
; Arguments: 1
;   RealNum~ = Real number to convert to a short string real number
; Returns: ShortReal$ the short string real number value of the real number.
;-------------------------------------------------------------------------------
(defun rtosr (RealNum~ / DimZin# ShortReal$)
  (setq DimZin# (getvar "DIMZIN"))
  (setvar "DIMZIN" 8)
  (setq ShortReal$ (rtos RealNum~ 2 8))
  (setvar "DIMZIN" DimZin#)
  ShortReal$
);defun rtosr
;-------------------------------------------------------------------------------
(defun C:DEMO (/ Bord ExcelApp FilePath Fonto Rang Sel Sht ShtNum Wbk)
(vl-load-com)
 
(setq FilePath (getfiled "Select Excel file to read :"
(getvar "dwgprefix")
"xls"
16
)
)
(setq ShtNum (getint "\nEnter sheet number <1>: "))
(if (not ShtNum)(setq ShtNum 1))
 
(setq ExcelApp (vlax-get-or-create-object "Excel.Application"))
(vla-put-visible ExcelApp :vlax-true);do not set to :vlax-false for invisible mode
(setq Wbk (vl-catch-all-apply 'vla-open
(list (vlax-get-property ExcelApp "WorkBooks") FilePath)))
(vlax-invoke-method Wbk "Activate") 
(setq Sht (vl-catch-all-apply 'vlax-get-property
(list (vlax-get-property Wbk "Sheets")
"Item" ShtNum)))
(vlax-invoke-method Sht "Activate")
;;Find last cell :
(vlax-invoke-method ExcelApp "Volatile")
(setq FindRang (vlax-get-property Sht "UsedRange"))
(setq RowNum (vlax-get-property
(vlax-get-property
FindRang "Rows") "Count"))
(setq lastRow (vlax-variant-value
(vlax-get-property (vlax-get-property
FindRang "Rows") "Item" RowNum)))
(setq lastCell (vlax-get-property lastRow "End" 2))
;;working with columns :
(setq Rang (vlax-variant-value
(vlax-get-property (vlax-get-property Sht "Columns")
"Item" 1))); 1 is column number
(vlax-put-property Rang "ColumnWidth" (vlax-make-variant 25.0 3)); 25.0 is new column width, 3 is variant type 
(vlax-put-property Rang "Horizontalalignment" (vlax-make-variant -4108 3))
;;working with rows :
;;; (setq Rang (vlax-get-property Sht "Range" "A:A"));get first row
;; the same as :
(setq Rang (vlax-variant-value
(vlax-get-property (vlax-get-property Sht "Rows")
"Item" 1))); 1 is row number
(vlax-put-property Rang "RowHeight" (vlax-make-variant 18.0 3)); 25.0 is new row height, 3 is variant type 
(vlax-put-property Rang "Horizontalalignment" (vlax-make-variant -4108 3))
(vlax-put-property (vlax-get-property Rang "Interior")
"Colorindex" (vlax-make-variant 4))
;;working with borders :
(setq Bord (vlax-get-property Rang "Borders"))
(vlax-put-property Bord "Color" (vlax-make-variant -1 3)) ; borders off
(vlax-put-property Bord "Color" (vlax-make-variant 1 3)) ;borders on
;; border lines (thin)
(vlax-put-property Bord "LineStyle" (vlax-make-variant 1 3))
;; borders color
(vlax-put-property Bord "Colorindex" (vlax-make-variant 5))
;;working with font :
(setq Fonto (vlax-get-property Rang "Font"))
(vlax-put-property Fonto "Name" (vlax-make-variant "Times New Roman" 12))
(vlax-put-property Fonto "Size" (vlax-make-variant 12 5))
(vlax-put-property Fonto "Bold" (vlax-make-variant 1 11))
(vlax-put-property Fonto "Italic" (vlax-make-variant 1 11))
(vlax-put-property Fonto "Colorindex" (vlax-make-variant 5));ETC
 
; continuing the code above
;; working with separate cell :
(vlax-invoke-method Rang "Activate");optional
(setq Cels (vlax-get-property Rang "Cells"))
(setq R1 1
C1 1)
(setq Cel (vlax-variant-value
(vlax-get-property Cels "Item"
;; row number :
(vlax-make-variant R1)
;; column number :
(vlax-make-variant C1))))
(vlax-put-property Cel "Value2" (vlax-make-variant "First Cell in Range" 12))
;; Set interior color :
(vlax-put-property (vlax-get-property Cel "Interior")
"Colorindex" (vlax-make-variant 28))
;; select the particular cell:
(vlax-invoke-method Cel "Select")
;; get application selection: 
(setq Sel (vlax-get-property ExcelApp "Selection"))
;; get selection borders
(setq Bords (vlax-get-property Sel "Borders"))
;; iterate through all edges of selection
(setq cnt 0)
(vlax-for a Bords
(setq cnt (1+ cnt))
(vl-catch-all-apply (function (lambda()
(progn 
(if (< cnt 5)
(progn 
(vlax-put-property a "LineStyle"
(vlax-make-variant 1 3))
(vlax-put-property a "Weight"
(vlax-make-variant 4 3))
(vlax-put-property a "ColorIndex"
(vlax-make-variant 1 5)));progn
;; turn off the diagonal lines:
(vlax-put-property a "LineStyle" (vlax-make-variant -4142 3))
))))))
;; Horizontal alignment Center :
(vlax-put-property Cel "Horizontalalignment" (vlax-make-variant -4108 3))
;; Vertical alignment Bottom :
(vlax-put-property Cel "VerticalAlignment" (vlax-make-variant -4107 3))
;; Set number format :
(vlax-put-property Cel "NumberFormat" (vlax-make-variant "0,00" 8))
(setq R1 1
C1 2)
(setq Cel (vlax-variant-value
(vlax-get-property Cels "Item"
;; row number :
(vlax-make-variant R1)
;; column number :
(vlax-make-variant C1))))
;; get cell value :
(setq cval (vlax-variant-value (vlax-get-property Cel "Value")))
;; Horizontal alignment Left(Indent) :
(vlax-put-property Cel "Horizontalalignment" (vlax-make-variant -4131 3))
;; Vertical alignment Center :
(vlax-put-property Cel "VerticalAlignment" (vlax-make-variant -4108 3))
;; Set text format :
(vlax-put-property Cel "NumberFormat" (vlax-make-variant "@" 8))
;; ETC
;;; (vl-catch-all-apply
;;; 'vlax-invoke-method
;;; (list Wbk "Close")
;;; );close file w/o saving of changes
 
;; *** or if you need to save changes :
 
;;;(vlax-invoke-method
;;;Wbk
;;;'SaveAs
;;;(vlax-get-property wbk "Name");short name
;;;-4143 ;exel file format (excel constant)
;;;nil
;;;nil
;;;:vlax-false
;;;:vlax-false
;;;1
;;;2
;;;)
;;; (vl-catch-all-apply
;;; 'vlax-invoke-method
;;; (list Wbk "Close" )
;;; )
;; **** 
;;; (vl-catch-all-apply
;;; 'vlax-invoke-method
;;; (list ExcelApp "Quit")
;;; )
(mapcar
(function (lambda (x)
(vl-catch-all-apply (function (lambda()
(if (not (vlax-object-released-p x))
 
(vlax-release-object x)
)
)
))))
(list Bord Bords Cel Fonto lastCell lastRow FindRang Rang Sel Sht Wbk ExcelApp)
)
(setq Bord nil
Bords nil
Fonto nil
Cel nil
Sel nil
Rang nil
Sht nil
Wbk nil
ExcelApp nil
)
(gc)
(gc)
(princ)
)

(princ);End of GetExcel.lsp
