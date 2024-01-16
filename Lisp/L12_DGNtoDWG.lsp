;* DGN_batch_modified.LSP - Converts a list of Microstation *.dgn drawings into AutoCAD *.dwg drawings
;                  Start command by typing DGNI
;
;                  Make the necessary adjustments to the following variables:
;                  ---------------------------------------------------------
;                  tx1 = path and name of a file that holds a list with names for all the *.dgn's to be imported,
;                        names of *.dgn drawings may be written without extension, as well as with extension,
;                        in plain text format, no return after the last line.
;                  tx2 = the path for the input folder, containing the actual *.dgn files to import.
;                  tx3 = the path for the output folder, where the drawings converted into *.dwg will be saved,
;                        (routine assumes that the *.dwg files do not exist yet)
;                  tx4 = name of the drawing model to import
;
;
;                  The routine reads drawing names from the file given in tx1 line-for-line.
;                  In each loop it performs a DGNIMPORT from the folder given as tx2 into the existing AutoCAD drawing,
;                  does a Zoom Extends, saves the converted drawing result as *.dwg in the folder given as tx3,
;                  and finally restores the drawing to its original state, ready to receive the next DGNIMPORT loop.
;
;                  The DELAY command for 1000 milliseconds (1 second) is needed to provide sufficient separation
;                  between the DGNIMPORT and SAVEAS processes (otherwise it starts to mix up drawings).
;
;                  The DGNIMPORT command trips when the name of the *.dgn to be imported contains a comma,
;                  I advise to rename drawings having this issue.
;
;                  Written by M. Moolhuysen. Modified by C. Matthews
;
;                  This software may not be sold as commercial product or included as part of a commercial product.


(defun C:L12_DGNI (/ fil tx1 tx2 tx3 tx4 tx5)
  (princ "Please select input folder. \n")
  (setq tx1 (vl-directory-files (setq tx2(acet-ui-pickdir)) "*.dgn"))          ;; example variable: file holding a list of *.dgn's names to be imported.
        ;tx2 "C:\\Users\\yourname\\Desktop\\Batch_Folder\\Input_Folder\\"       ;; example variable: input folder.
  (princ "Please select output folder. \n")
  (setq tx3 (acet-ui-pickdir)      ;; example variable: output folder.
        tx4 "Default"                                                          ;; example variable: drawing model name
  )
  (setvar "DGNIMPORTMODE" 1)
  ;(setq fil (open tx1 "r")
  ;      tx5 (read-line fil))         ; repeats program until all lines from the list with *.dgn drawing names are read.
  ;(while tx5                         ; strips an extension with length of 3 characters from the drawing name, if present.
  (foreach tx5 tx1
    (if (wcmatch tx5 "*`.???")
      (setq tx5 (substr tx5 1 (- (strlen tx5) 4)))
    )
    (command "_UNDO" "_MARK"
             "_-DGNIMPORT" (strcat tx2 "\\" tx5) tx4 "" ""
             "_ZOOM" "_E"
             "._DELAY" 500
             "_SAVEAS" "2007(LT2007)" (strcat tx3 tx5)	 
    )
	(command "_ERASE" "ALL" "")                ;erases everything on the page after the save
	(command "_.purge" "_all" "" "_no")        ;purges everything so you don't carry it over to the next drawing
	(command "_.purge" "_regapp" "" "_no")
	(command "_QNEW")                          ;opens a new drawing
    ;(setq tx5 (read-line fil))
  )
   ;(close fil)
  (command "_QUIT" "_Y")
  (princ)
)