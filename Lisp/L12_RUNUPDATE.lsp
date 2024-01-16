;;-----[ Lab2012 UPDATE SYSTEM]----------------
(defun updatefunction (LabPathDest List1 / Temp PMPPath UserPath PlotPath PlotStyles DirNew DirLengthNew Printers)
  (vl-load-com)

  ;Modus
  (setq Printers (nth 1 List1))
  
  ;Default paden
  (setq *olderr* *error* *error* my-error)
  (setq Temp (getenv "Temp"))
  (setq UserPath (getenv "Appdata"))
  (setq PlotPath (strcat(getenv "PrinterConfigDir")"\\"))
  (setq PMPPath (strcat(getenv "PrinterDescDir")"\\"))
  (setq PlotStyles (strcat(getenv "PrinterStyleSheetDir")"\\"))
  
  (princ "\nExitting autocad")
  (setq scriptfile (findfile "L12_update.vbs")) 
  (startapp (strcat "CSCRIPT.EXE //nologo " (vl-prin1-to-string scriptfile)
;   " " (vl-prin1-to-string LabPathSource)
   " " (vl-prin1-to-string LabPathDest)
   " " (vl-prin1-to-string Temp)
   " " (vl-prin1-to-string UserPath)
   " " (vl-prin1-to-string PlotPath)
   " " (vl-prin1-to-string PMPPath)
   " " (vl-prin1-to-string PlotStyles)
   " " (vl-prin1-to-string Printers)
   " " (vl-prin1-to-string "https://github.com/JoakinKirschen/lab2012/archive/master.zip")
   ))
   
  
  
;  (DeleteFolder LabPathDest)
;  (CopyFolder LabPathSource LabPathDest)
;
;
  ;update plotters
;  (if (= Printers "1")
;    (progn
;	(setq DirNew  (vl-directory-files  (strcat LabPathSource "\\Files\\Plotters") "*.*" 0))
;    (setq DirLengthNew (vl-list-length  DirNew))
;    (while (> DirLengthNew 0)
;      (progn
;        (setq DirLengthNew (- DirLengthNew 1))
;        (vl-file-delete  (strcat PlotPath (nth DirLengthNew DirNew)))
;        (vl-file-copy (strcat LabPathSource "\\Files\\Plotters\\" (nth DirLengthNew DirNew))
;                      (strcat PlotPath (nth DirLengthNew DirNew))
;        )
;      )
;    )
;
;    (setq DirNew  (vl-directory-files  (strcat LabPathSource "\\Files\\PMP Files") "*.*" 0))
;    (setq DirLengthNew (vl-list-length  DirNew))
;    (while (> DirLengthNew 0)
;      (progn
;        (setq DirLengthNew (- DirLengthNew 1))
;        (vl-file-delete  (strcat PMPPath (nth DirLengthNew DirNew)))
;        (vl-file-copy (strcat LabPathSource "\\Files\\PMP Files\\" (nth DirLengthNew DirNew))
;                      (strcat PMPPath (nth DirLengthNew DirNew))
;        )
;      )
;    )

;    (setq DirNew  (vl-directory-files  (strcat LabPathSource "\\Files\\Plot Styles") "*.*" 0))
;    (setq DirLengthNew (vl-list-length  DirNew))
;    (while (> DirLengthNew 0)
;      (progn
;        (setq DirLengthNew (- DirLengthNew 1))
;        (vl-file-delete  (strcat PlotStyles (nth DirLengthNew DirNew)))
;        (vl-file-copy   (strcat LabPathSource "\\Files\\Plot Styles\\" (nth DirLengthNew DirNew))
;                        (strcat PlotStyles (nth DirLengthNew DirNew))
;        )
;      )
;    )
;    (princ "\nPlotters Updated")
;    )
;  )
;(DeleteFolder LabPathSource)
;(alert "Update Successful.\nPlease restart Autocad.")
;(exit)
;)
;
;(defun MY-ERROR (s)
;    (if (not (member s            ; msgs of the english version:
;       '("Function cancelled" "console break" "quit / exit abort")))
;      (princ (strcat "\nError: " s))
;    )
;    (setq *error* *olderr*)
)
