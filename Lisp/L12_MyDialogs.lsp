(defun c:AddToBlockCol (/ ocmd DirPath DwgList DiaRtn tmpList tmpName)

(setq ocmd (getvar "cmdecho"))
(setvar "cmdecho" 0)
(if
 (and
  (setq DirPath (Directory-Dia "Select directory of drawing files/"))
  (setq DwgList (vl-directory-files DirPath "*.dwg" 1))
  (setq DwgList (vl-sort DwgList '(lambda (a b) (< (strcase a) (strcase b)))))
  (setq DiaRtn (MultiSelect DwgList "Select toggle to add all." T))
  (if (/= (car DiaRtn) T)
   (progn
    (foreach Num DiaRtn
     (setq tmpList (cons (nth Num DwgList) tmpList))
    )
    (setq DwgList tmpList)
   )
   T
  )
 )
 (foreach BlkName DwgList
  (if (tblsearch "Block" (setq tmpName (vl-filename-base BlkName)))
   (progn
    (command "_.insert" (strcat tmpName "=" DirPath BlkName))
    (command)
   )
   (progn
    (command "_.insert" (strcat DirPath BlkName))
    (command)
   )
  )
 )
)
(princ)
(setvar "cmdecho" ocmd)
)
;--------------------------------------------------------------------------------------
(defun Directory-Dia ( Message / sh folder folderobject result)
;; By Tony Tanzillo
;; Modified by Tim Willey

  (vl-load-com)
  (setq sh
     (vla-getInterfaceObject
        (vlax-get-acad-object)
        "Shell.Application"
     )
  )


  (setq folder
     (vlax-invoke-method
         sh
         'BrowseForFolder
         (vla-get-HWND (vlax-get-Acad-Object))
         Message
         0
      )
  )
  (vlax-release-object sh)


  (if folder
     (progn
        (setq folderobject
           (vlax-get-property folder 'Self)
        )
        (setq result
           (vlax-get-property FolderObject 'Path)
        )
        (vlax-release-object folder)
        (vlax-release-object FolderObject)
        (if (/= (substr result (strlen result)) "\\")
          (setq result (strcat result "\\"))
          result
        )
     )
  )
)
;--------------------------------------------------------------------------
(defun MultiSelect (Listof Message Toggle / DiaLoad tmpStr tmpTog tmpList)

(setq DiaLoad (load_dialog "MyDialogs.dcl"))
(if (new_dialog "MultiSelect" DiaLOad)
 (progn
  (start_list "listbox" 3)
  (mapcar 'add_list Listof)
  (end_list)
  (if Message
   (set_tile "text1" Message)
  )
  (if (not Toggle)
   (mode_tile "toggle1" 1)
  )
  (mode_tile "listbox" 2)
  (action_tile "accept"
   "(progn
    (setq tmpStr (get_tile \"listbox\"))
    (if Toggle
     (setq tmpTog (get_tile \"toggle1\"))
    )
    (done_dialog 1)
   )"
  )
  (action_tile "cancel" "(done_dialog 0)")
  (if (= (start_dialog) 1)
   (progn
    (setq tmpList (read (strcat "(" tmpStr ")")))
    (if (= tmpTog "1")
     (cons T tmpList)
     tmpList
    )
   )
  )
 )
)
)