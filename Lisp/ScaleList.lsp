;;; ==========================================================================
;;; File: SCALELIST.lsp
;;; Purpose: Scale list deletion and management for AutoCAD 2008
;;; Author: Steve Johnson
;;; Date: 13 August 2007
;;; Version: 1.0
;;; Copyright: (c) 2007 cad nauseam (www.cadnauseam.com)
;;; May be distributed and used freely provided this header is retained in full
;;; --------------------------------------------------------------------------
;;; Commands:
;;;  SCALELIST
;;;   Deletes all existing scales and sets up metric scales. For use only in
;;;   setting up scales in templates and pre-2008 drawings.
;;;   WARNING: potentially destructive to annotative objects!
;;; --------------------------------------------------------------------------
;;; Functions:
;;;  (scaledel_all_unsafe)
;;;   Deletes all scales in the current drawing, including 1:1 and scales in
;;;   use.
;;;   WARNING: potentially destructive to annotative objects!
;;;  (scaledel_wcard_unsafe WCARD-OR-LIST)
;;;   If WCARD-OR-LIST is a wildcard string, deletes scales that match that
;;;   wildcard, excluding 1:1 but including scales in use.
;;;   If WCARD-OR-LIST is a list of scale names, deletes those scales,
;;;   including 1:1 (if listed) and scales in use.
;;;   WARNING: potentially destructive to annotative objects!
;;;  (scaledel_long_xref LONG-SCALE-LIST)
;;;   Cleans up those scales that are too long to delete using the command-line
;;;   (i.e. over 132 characters). These are usually only those created by the
;;;   AutoCAD 2008 pre-SP1 bug that created _XREF_XREF_XREF scales, and this
;;;   is checked before deletion.
;;;  (scaledel_warning)
;;;   Issues a warning and asks user to enter Yes before continuing.
;;;  (scaledel_get_scalelist)
;;;   Returns a list of scales in the drawing.
;;;  (scaledel_all)
;;;   Deletes all scales other than 1:1 and scales in use.
;;;  (scaledel_reset)
;;;   Performs a -SCALELIST Reset command.
;;;  (scaledel_smart_reset)
;;;   Performs a -SCALELIST Reset command if it is likely to reduce the number
;;;   of scales in the list, prior to setting things up.
;;;  (scaledel_wcard WCARD)
;;;   Deletes scales that match WCARD, excluding 1:1 and scales in use.
;;;  (scaledel_create_scales SCALES)
;;;   Creates a set of scales defined in list SCALES.
;;;  (scaledel_create_metric)
;;;   Creates a set of metric scales: see *** in code to adjust list.


(if (>= (atof (substr (getvar "ACADVER") 1 4)) 17.1)
  (progn ; Only define these functions if they will work (ie. 2008 or later)


    (prompt "\nLoading SCALELIST.lsp Version 1.0... ")
;;; --------------------------------------------------------------------------


    (defun C:SCALELIST ()
      (if (= (scaledel_warning) "Yes")
        (progn
          (scaledel_smart_reset)
          (prompt "\nDeleting all existing scales...")
          (scaledel_all_unsafe)
          (prompt "\nCreating metric scales...")
          (scaledel_create_metric)
        )
      )
      (princ)
    ) ; End C:SCALELIST



;;; --------------------------------------------------------------------------
;;; Functions


    (defun scaledel_all_unsafe (/ scale-en-list)
      (foreach item (dictsearch (namedobjdict) "ACAD_SCALELIST")
        (if (= 350 (car item))
          (setq scale-en-list (cons (cdr item) scale-en-list))
        )
      )
      (foreach item scale-en-list
        (entdel item)
      )
    ) ; End scaledel_all_unsafe


    (defun scaledel_wcard_unsafe (WCARD-OR-LIST / scale-list scale)
      (foreach item (dictsearch (namedobjdict) "ACAD_SCALELIST")
        (if (= 350 (car item))
          (setq
            scale-list
            (cons
              (cons (strcase (cdr (assoc 300 (entget (cdr item))))) (cdr item))
              scale-list
            )
          )
        )
      )
      (if (= (type WCARD-OR-LIST) 'STR)
        (foreach item scale-list
          (if
            (and
              (wcmatch (car item) (strcase WCARD))
              (/= (car item) "1:1")
            )
            (entdel (cdr item))
          )
        )
        (foreach item WCARD-OR-LIST
          (if (setq scale (assoc (strcase item) scale-list))
            (entdel (cdr scale))
          )
        )
      )
    ) ; End scaledel_wcard_unsafe


    (defun scaledel_long_xref (LONG-SCALE-LIST / scale-list)
      (foreach scale LONG-SCALE-LIST
        (if (wcmatch (strcase scale) "*_XREF_XREF_XREF*")
          (setq scale-list (cons scale scale-list))
        )
      )
      (if scale-list
        (progn
          (prompt "\nDeleting the following long _XREF scale(s):")
          (foreach scale scale-list
            (prompt (strcat "\n " scale))
          )
          (scaledel_wcard_unsafe scale-list)
        )
      )
    ) ; End scaledel_long_xref


    (defun scaledel_warning ()
      (initget "Yes No")
      (getkword
        (strcat
          "\nThis command will first destroy all existing scales including those in use."
          "\nAre you sure you want to do this? [Yes/No] <No>: "
        )
      )
    ) ; End scaledel_warning


    (defun scaledel_get_scalelist (/ scale-list)
      (foreach item (dictsearch (namedobjdict) "ACAD_SCALELIST")
        (if (= 350 (car item))
          (setq
            scale-list
            (cons (strcase (cdr (assoc 300 (entget (cdr item))))) scale-list)
          )
        )
      )
      scale-list
    ) ; End scaledel_get_scalelist


    (defun scaledel_all ()
      (scaledel_smart_reset)
      (scaledel_long_xref (scaledel_wcard "*"))
    ) ; End scaledel_all


    (defun scaledel_reset (/ cmdecho)
      (setq cmdecho (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.-SCALELISTEDIT" "_R" "_Y" "_E")
      (setvar "CMDECHO" cmdecho)
    ) ; End scaledel_reset


    (defun scaledel_smart_reset ()
      (if (> (length (scaledel_get_scalelist)) 40)
        (scaledel_reset)
      )
    ) ; End scaledel_smart_reset


    (defun scaledel_wcard (WCARD / scale-list cmdecho long-scale-list)
      (foreach scale (scaledel_get_scalelist)
        (if
          (and
            (wcmatch (strcase scale) (strcase WCARD))
            (/= scale "1:1")
          )
          (setq scale-list (cons scale scale-list))
        )
      )
      (if scale-list
        (progn
          (setq cmdecho (getvar "CMDECHO"))
          (setvar "CMDECHO" 0)
          (command "_.-SCALELISTEDIT")
          (foreach item scale-list
            (if (<= (strlen item) 132)
              (command "_D" item) ; Attempt to delete scale
              (setq long-scale-list (cons item long-scale-list))
            )
          )
          (command "_E")
          (setvar "CMDECHO" cmdecho)
        )
      )
      long-scale-list ; Returns list of scales too long to delete
    ) ; End scaledel_wcard


    (defun scaledel_create_scales (SCALES / scale-list-all cmdecho)
      (setq
        scale-list-all (scaledel_get_scalelist)
        cmdecho (getvar "CMDECHO")
      )
      (setvar "CMDECHO" 0)
      (command "_.-SCALELISTEDIT")
      (foreach scale SCALES
        (if (not (member (strcase (car scale)) scale-list-all))
          (command "_A" (car scale) (cadr scale))
        )
      )
      (command "_E")
      (setvar "CMDECHO" cmdecho)
    ) ; End scaledel_create_scales


;;; --------------------------------------------------------------------------


    (defun scaledel_create_metric ()
      (scaledel_create_scales
        '(
          ("1:1" "1:1")
          ("1:2" "1:2")
          ("1:5" "1:5")
          ("1:10" "1:10")
          ("1:20" "1:20")
          ("1:50" "1:50")
          ("1:100" "1:100")
          ("1:200" "1:200")
          ("1:500" "1:500")
          ("1:1000" "1:1000")
          ("1:2000" "1:2000")
          ("1:5000" "1:5000")
          ("1:10000" "1:10000")
          ("1:20000" "1:20000")
          ("1:50000" "1:50000")
         )
      )
    ) ; End scaledel_create_metric


    (prompt
      (strcat
        "SCALELIST"
        "commands loaded.\n"
      )
    )


  ) ; End progn to test for AutoCAD release
  (prompt "\nRequires AutoCAD 2008 or above.")
)

(princ)

;;; ==========================================================================
;;; End of file ScaleList.lsp
;;; ==========================================================================