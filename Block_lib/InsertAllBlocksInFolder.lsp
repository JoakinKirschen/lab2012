(defun c:InsertAll ( / cmd dir extn )

    (setq extn "dwg") ;; Extension of files to Insert e.g "dwg"

    (if (setq dir (LM:DirectoryDialog (strcat "Select Directory of " (strcase extn) " Files to Insert") nil 512))
        (progn
            (setq cmd (getvar 'CMDECHO))
            (setvar 'CMDECHO 0)
            (foreach file (vl-directory-files dir (strcat "*." extn) 1)
                (vl-cmdf "_.-insert" (strcat dir "\\" file) "_S" 1.0 "_R" 1.0 "_non" '(0 0 0))
            )
            (setvar 'CMDECHO cmd)
        )
        (princ "\n*Cancel*")
    )
    (princ)
)

;;-------------------=={ Directory Dialog }==-----------------;;
;;                                                            ;;
;;  Displays a dialog prompting the user to select a folder   ;;
;;------------------------------------------------------------;;
;;  Author: Lee Mac, Copyright © 2011 - www.lee-mac.com       ;;
;;------------------------------------------------------------;;
;;  Arguments:                                                ;;
;;  msg  - message to display at top of dialog                ;;
;;  dir  - root directory (or nil)                            ;;
;;  flag - bit coded flag specifying dialog display settings  ;;
;;------------------------------------------------------------;;
;;  Returns:  Selected folder filepath, else nil              ;;
;;------------------------------------------------------------;;

(defun LM:DirectoryDialog ( msg dir flag / Shell Fold Self Path )
    (vl-catch-all-apply
        (function
            (lambda ( / ac HWND )
                (if
                    (setq Shell (vla-getInterfaceObject (setq ac (vlax-get-acad-object)) "Shell.Application")
                          HWND  (vl-catch-all-apply 'vla-get-HWND (list ac))
                          Fold  (vlax-invoke-method Shell 'BrowseForFolder (if (vl-catch-all-error-p HWND) 0 HWND) msg flag dir)
                    )
                    (setq Self (vlax-get-property Fold 'Self)
                          Path (vlax-get-property Self 'Path)
                          Path (vl-string-right-trim "\\" (vl-string-translate "/" "\\" Path))
                    )
                )
            )
        )
    )
    (if Self  (vlax-release-object  Self))
    (if Fold  (vlax-release-object  Fold))
    (if Shell (vlax-release-object Shell))
    Path
)

(vl-load-com) (princ)