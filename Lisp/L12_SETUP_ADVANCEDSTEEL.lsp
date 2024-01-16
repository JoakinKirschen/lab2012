(prompt "\nType \"L12Setup\" to run......")

;main function
(defun c:L12SETUP ( / scriptloc temp usname defpath vrs CD YR acadprofiles actprofile targ source targ1 targ2 targ3 targ4 targ5 npname maincui #Files #Layout mcui)
(vl-load-com)
(setvar "impliedface" 0)
(setvar "cmdecho" 0)

(setq CD (rtos (getvar "CDATE") 2 4))
(setq YR (strcat (substr CD 7 2)"-" (substr CD 5 2) "-" (substr CD 1 4)))

(setq vrs (L12_GetLastFolder(vl-filename-directory (findfile (strcat (getvar "PROGRAM") ".exe")))))

(setq targ1 (strcat (getenv "appdata") "\\Autodesk\\" vrs ))  
(setq targ2 (strcat targ1 "\\lab2012" ))  
(setq targ3 (strcat targ1 "\\kitek_steel" ))  
(setq targ4 (strcat targ1 "\\ACad_Cust" ))  
(setq targ5 (strcat (getenv "appdata") ))  

;(setq source2 "0")
;(setq source3 "0")

;(if (setq source2 (findfile "\\\\BEZELFS02\\Projecten$\\000 - GmI Standaards\\Bibliotheek bouwkunde\\1 CAD software\\LAB2012\\lab2012\\LAB2012.mnl"))
;(princ "Lab 2012 mnl found!\n")
;(while (and (/= source2 nil)(/= (vl-filename-base source2) "LAB2012"))
;(setq source2 (getfiled "Search LAB2012.mnl" "LAB2012.mnl" "mnl" 0))
;))

;(if (setq source3 (findfile "\\\\BEZELFS02\\Projecten$\\000 - GmI Standaards\\Bibliotheek bouwkunde\\1 CAD software\\LAB2012\\kitek_steel\\KT_Stl.lin"))
;(princ "KT_Stl.lin found!\n")
;(while (and (/= source3 nil)(/= (vl-filename-base source3) "KT_Stl"))
;(setq source3 (getfiled "Search KT_Stl.lin" "KT_Stl.lin" "lin" 0))
;))

(if (vl-file-directory-p targ2)
(stu:DeleteFolder targ2)
)

(if (vl-file-directory-p targ3)
(stu:DeleteFolder targ3)
)


(if (not(vl-file-directory-p targ1))
(stu:CreateFolder targ1)
)

(setq Temp (getenv "Temp"))
(setq source3 (strcat (getenv "Temp") "\\kitek_steel"))
;(setq targ3 (vl-filename-directory (findfile "KT_Stl.lin")))
(setq scriptfile (create_updvbs))

(princ "\nStart downloading sourcefiles Kitek Steel\n")
  (startapp (strcat "CSCRIPT.EXE //nologo " (vl-prin1-to-string scriptfile)
;     " " (vl-prin1-to-string LabPathSource)
     " " (vl-prin1-to-string targ3)
     " " (vl-prin1-to-string Temp)
     " " (vl-prin1-to-string "https://github.com/JoakinKirschen/kitek_steel/archive/master.zip")
     ))
	 
(setq count 0)
(while (and (<= count 100)(not (findfile (strcat targ3 "\\KT_Stl.LSP"))))(setup_wait 1)(princ count)(setq count (+ count 1))	)
(if (> count 97)(progn (princ "Downloading Kitek Steel from source failed. Please try again")(exit)))
(setup_wait 10)	

(setq Temp (getenv "Temp"))
;(setq source3 (strcat (getenv "Temp") "\\lab2012"))
;(setq targ3 (vl-filename-directory (findfile "KT_Stl.lin")))
(setq scriptfile (create_updvbs))

(princ "\nStart downloading sourcefiles Lab2012")
  (startapp (strcat "CSCRIPT.EXE //nologo " (vl-prin1-to-string scriptfile)
;     " " (vl-prin1-to-string LabPathSource)
     " " (vl-prin1-to-string targ2)
     " " (vl-prin1-to-string Temp)
     " " (vl-prin1-to-string "https://github.com/JoakinKirschen/lab2012/archive/master.zip")
     ))

(setq count 0)
(while (and (<= count 200)(not (findfile (strcat targ2 "\\LAB2012.mnl"))))(setup_wait 1)(princ count)(setq count (+ count 1))	)	 
(if (> count 197)(progn (princ "Downloading LAB2012 from source failed. Please try again")(exit)))	 
(setup_wait 10)	 
	 
;(princ "Copying files... This can take a while please be patient!")

;(setq source2 (vl-filename-directory source2))
;(setq source3 (vl-filename-directory source3))

(princ "\nCreating shortcut")
(if (findfile (strcat (getvar "PROGRAM") ".exe"))
	(progn
	(setq ExePath(vl-princ-to-string (findfile (strcat (getvar "PROGRAM") ".exe"))))
	(setq scriptloc (strcat targ2 "\\L12_Shortcut.vbs"))
	(startapp (strcat "CSCRIPT.EXE //nologo " (vl-prin1-to-string scriptloc)
	;   " " (vl-prin1-to-string LabPathSource)
	   " " (vl-prin1-to-string vrs)
	   " " (vl-prin1-to-string ExePath)
	))
	)
);if

;(if (not(vl-file-directory-p targ5))
;(stu:CreateFolder targ5)
;)



;(if (vl-file-directory-p targ2)
;(stu:DeleteFolder targ2)
;)

;(if (vl-file-directory-p targ3)
;(stu:DeleteFolder targ3)
;)

;(if (not(vl-file-directory-p targ4))
;(stu:CreateFolder targ4)
;)
;(princ "test3")
;(stu:CreateFolder targ2)
;(stu:CreateFolder targ3)
;(stu:CopyFolder source2 targ2)
;(stu:CopyFolder source3 targ3)

(setq acadprofiles (vla-get-profiles (vla-get-preferences (vlax-get-Acad-Object))))

;get the active profile
(setq actprofile (vla-get-ActiveProfile acadprofiles))

;(setq newProfile (vlax-invoke-method acadprofiles 'ImportProfile "LAB2012" (strcat source2 "\\LAB2012.arg") :vlax-true))
;if it's not, copy the existing profile, renaming it "AfraLisp".
;(vlax-invoke-method acadProfiles 'CopyProfile actProfile (strcat "L12_" YR))
;reset the active profile
;(vlax-invoke-method acadProfiles 'ResetProfile (strcat "L12_" YR))
;then make it the active profile
;(vla-put-ActiveProfile acadProfiles "LAB2012")
;(setq npname (L12-get-unique-profile-name "LAB2012_"))
;(L12-profile-import (strcat targ2 "\\LAB2012.arg") npname T)
;(L12-profile-set-active npname)

;(setq list2 (vl-directory-files targ2 nil -1))    Te testen op netwerk locaties
;(setq list3 (vl-directory-files targ3 nil -1))    Te testen op netwerk locaties

;store the default paths
(setq defpath (getenv "ACAD"))

;set up the support paths
(princ "\nSetting up the support paths")
(setenv "ACAD" (strcat 
defpath ";"
targ2 ";"
targ2 "\\" "Lisp;"
targ2 "\\" "Blocks;"
targ2 "\\" "Files;"
targ2 "\\" "Fonts;"
targ2 "\\" "Icons;"
targ2 "\\" "Block_lib;"
targ3 ";"
targ3 "\\" "Blocks ;"
))

(princ "\nSetting up the trusted paths")

(if (>= (getvar "ACADVER") "19.1")(if 'trustedpaths (setvar 'trustedpaths (getenv "ACAD"))))

(setq winmain (substr (getvar 'LOCALROOTPREFIX) 1 3))
;(if (setq maincui (findfile (strcat winmain "program files\\autodesk\\" vrs "\\UserDataCache\\Support\\acad.cuix")))
;(stu:CopyFile maincui (setq mcui(strcat targ4 "\\acadcust_" YR ".cuix")))
;(if (setq maincui (findfile (strcat winmain "program files\\autodesk\\Acad_2011\\UserDataCache\\Support\\acad.cuix")))
;(stu:CopyFile maincui (setq mcui(strcat targ4 "\\acadcust_" YR ".cuix")))
;(progn
;(setq maincui "0")
;(while (and (/= maincui nil)(/= (vl-filename-base maincui) "LAB2012"))
;(setq maincui (getfiled "Search acad.cui*" "acad.cui*" "cui" 0))
;)
;(stu:CopyFile maincui (setq mcui(strcat targ4 "\\acadcust_" YR ".cuix")))
;)
)
)
(princ "\nCreating Lab2012 profile")
(and
    (not
      (vl-catch-all-error-p
        (vl-catch-all-apply
          '(lambda ()
             (setq #Files  (vla-get-files(vla-get-preferences (vlax-get-acad-object))) ;_ vla-get-files
                   #Layout (vla-get-activelayout
                             (vla-get-activedocument (vlax-get-acad-object))
                           ) ;_ vla-get-activelayout
             ) ;_ setq
			 (setq usname (getvar "loginname"))
			 (stu:CreateFolder targ5)
			 (stu:CreateFolder (strcat targ5 "\\Autocad"))
			 (stu:CreateFolder (strcat targ5 "\\Autocad\\AutoSave"))
			 (stu:CreateFolder (strcat targ5 "\\Autocad\\Temp"))
			 (stu:CreateFolder (strcat targ5 "\\Autocad\\TempXref"))
			 ;; *********************
             ;; **  AutoSave Path  **
             ;; *********************
             (vla-put-autosavepath #Files (strcat winmain usname "\\Autocad\\AutoSave"))
             ;; ***************************
             ;; **  Main Cui File  **
             ;; ***************************
			 ;;(vla-put-menufile #Files mcui)
			 ;(command "._Menu" mcui)
			 ;; ***************************
             ;; **  Temp File Location  **
             ;; ***************************
             (vla-put-TempFilePath #Files (strcat winmain usname "\\Autocad\\Temp"))
			 ;; ***************************
             ;; **  Temp xref Location  **
             ;; ***************************
             (vla-put-TempXrefPath #Files (strcat winmain usname "\\Autocad\\TempXref"))
             ;; *********************
             ;; **  QNew Template  **
             ;; *********************
             ;(vla-put-QNewTemplateFile
             ;  #Files
             ;  (strcat (getvar 'LOCALROOTPREFIX) "template\\acadiso.dwt")
             ;) ;_ vla-put-QNewTemplateFile
           ) ;_ lambda
        ) ;_ vl-catch-all-apply
      ) ;_ vl-catch-all-error-p
    ) ;_ not
  ) ;_ and
  
  (if (setq temp (findfile (strcat winmain "program files (x86)\\Microsoft Office\\Office11\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
  (if (setq temp (findfile (strcat winmain "program files\\Microsoft Office\\Office11\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
  (if (setq temp (findfile (strcat winmain "program files (x86)\\Microsoft Office\\Office12\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
  (if (setq temp (findfile (strcat winmain "program files\\Microsoft Office\\Office12\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
   (if (setq temp (findfile (strcat winmain "program files (x86)\\Microsoft Office\\Office13\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
  (if (setq temp (findfile (strcat winmain "program files\\Microsoft Office\\Office13\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
   (if (setq temp (findfile (strcat winmain "program files (x86)\\Microsoft Office\\Office14\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
  (if (setq temp (findfile (strcat winmain "program files\\Microsoft Office\\Office14\\excel.exe")))
  (setenv "L12_ExcelPath" temp)
  )  )  )  )  )  )  )  )
  
;  (if (setq temp (findfile "\\\\BEZELFS02\\Projecten$\\000 - GmI Standaards\\Bibliotheek bouwkunde\\1 CAD software\\LAB2012\\lab_version.txt"))
; (setenv "L12_UpdatePath" temp)
; )
  
(princ "\nLoading cui files") 
(stu:menuload "lab2012.cuix")
(menucmd "p30=+Lab2012.POPL1")
(menucmd "p30=+Lab2012.POPL2")
(menucmd "p30=+Lab2012.POPL3")
(stu:menuload "KT_Stl.cuix")
(stu:menuload "Mod.cuix")
(prompt "Setting printers")
(stu:printers targ2)
(SETVAR "POLARADDANG" "45;135;225;315") 
(setvar "POLARDIST" 0)
(setvar "POLARMODE" 6)
(setvar "menubar" 1)
;(setvar "WSCURRENT" "AutoCAD Classic")
(command ".-WSsave" "Lab2012")
;(setvar "WSCURRENT" "Lab2012")
(alert
      (strcat
        "AutoCAD has been setup for Sweco.\n\n"
        "      Please restart AutoCAD."
      ) ;_ strcat
) ;_ alert
)


;-------------------------------------------------------
(defun stu:printers ( LabPathSource / PlotPath PMPPath PlotStyles DirNew DirLengthNew FILE)
    (setq PlotPath (strcat(getenv "PrinterConfigDir")"\\"))
    (setq PMPPath (strcat(getenv "PrinterDescDir")"\\"))
    (setq PlotStyles (strcat(getenv "PrinterStyleSheetDir")"\\"))
	(setq DirNew  (vl-directory-files  (strcat LabPathSource "\\Files\\Plotters") "*.*" 0))
    (setq DirLengthNew (vl-list-length  DirNew))
    (while (> DirLengthNew 0)
      (progn
        (setq DirLengthNew (- DirLengthNew 1))
        (vl-file-delete  (strcat PlotPath (nth DirLengthNew DirNew)))
        (vl-file-copy (strcat LabPathSource "\\Files\\Plotters\\" (nth DirLengthNew DirNew))
                      (strcat PlotPath (nth DirLengthNew DirNew))
        )
      )
    )

    (setq DirNew  (vl-directory-files  (strcat LabPathSource "\\Files\\PMP Files") "*.*" 0))
    (setq DirLengthNew (vl-list-length  DirNew))
    (while (> DirLengthNew 0)
      (progn
        (setq DirLengthNew (- DirLengthNew 1))
        (vl-file-delete  (strcat PMPPath (nth DirLengthNew DirNew)))
        (vl-file-copy (strcat LabPathSource "\\Files\\PMP Files\\" (nth DirLengthNew DirNew))
                      (strcat PMPPath (nth DirLengthNew DirNew))
        )
      )
    )

    (setq DirNew  (vl-directory-files  (strcat LabPathSource "\\Files\\Plot Styles") "*.*" 0))
    (setq DirLengthNew (vl-list-length  DirNew))
    (while (> DirLengthNew 0)
      (progn
        (setq DirLengthNew (- DirLengthNew 1))
        (vl-file-delete  (strcat PlotStyles (nth DirLengthNew DirNew)))
        (vl-file-copy   (strcat LabPathSource "\\Files\\Plot Styles\\" (nth DirLengthNew DirNew))
                        (strcat PlotStyles (nth DirLengthNew DirNew))
        )
      )
    )
    (princ "\nPlotters Updated")
)


(defun stu:menuload (CUIFILE / FILE)
(if (= (menugroup CUIFILE) nil)
(progn
(if (setq FILE (findfile CUIFILE))
(progn (SETVAR "FILEDIA" 0)
(command "menuload" CUIFILE)
(SETVAR "FILEDIA" 1)
))
)
)
)
;(ppn_menuload_tb) 
;; Voorbeeldfuncties

(defun RGB->Bits(RGB_List)
  (if(vl-every
       '(lambda(c)(and(< -1 c)(> 256 c)))RGB_List)
     (apply '+(mapcar '* RGB_List '(65536 256 1)))
    ); end if
  ); end of RGB->Bits


(defun Bits->RGB(Bits / r g)
  (if(and(< -1 Bits)(> 16777216 Bits))
  (list(setq r(/ Bits 65536))
       (setq g(/(- Bits(* r 65536))256))
       (- Bits(+(* r 65536)(* g 256)))
       ); end list
    ); end if
  ); end Bits->RGB

;  call example   
;  (RGB->Bits '(255 0 255))
;  (Bits->RGB 16711935)


;;;
;;;    Copyright (C) 2002 by Autodesk, Inc.
;;;
;;;    Permission to use, copy, modify, and distribute this software
;;;    for any purpose and without fee is hereby granted, provided
;;;    that the above copyright notice appears in all copies and
;;;    that both that copyright notice and the limited warranty and
;;;    restricted rights notice below appear in all supporting
;;;    documentation.
;;;
;;;    AUTODESK PROVIDES THIS PROGRAM "AS IS" AND WITH ALL FAULTS.
;;;    AUTODESK SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTY OF
;;;    MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE.  AUTODESK, INC.
;;;    DOES NOT WARRANT THAT THE OPERATION OF THE PROGRAM WILL BE
;;;    UNINTERRUPTED OR ERROR FREE.
;;;
;;;    Use, duplication, or disclosure by the U.S. Government is subject to
;;;    restrictions set forth in FAR 52.227-19 (Commercial Computer
;;;    Software - Restricted Rights) and DFAR 252.227-7013(c)(1)(ii) 
;;;    (Rights in Technical Data and Computer Software), as applicable.
;;;
;;;
;;; DESCRIPTION: 
;;;  Sample profile manipulation utilities. All functions return T on success and nil 
;;  on failure. See comments above each function for additional details.
;;;
;;; EXAMPLES:
;;;   
;;; - Set active profile: 
;;;     (L12-profile-set-active "MyProfile")
;;;
;;; - Import a profile:
;;;     (L12-profile-import "c:\\myExportedProfile.arg" "MyFavoriteProfile" T)
;;;
;;; - Delete a profile:
;;;     (L12-profile-delete "unwanted")
;;;
;;;
;;; - Import a profile, even if it already exists, and set it active.
;;;
;;;    (L12-profile-import "c:\\CompanyProfile.arg" "MyProfile" T)
;;;    (L12-profile-set-active "MyProfile")
;;;
;;;
;;; - Import a profile, if not already present, and set it active
;;;
;;;    (if (not (L12-profile-exists "myProfile"))
;;;        (progn
;;;         (L12-profile-import "c:\\CompanyProfile.arg" "MyProfile" T)
;;;         (L12-profile-set-active "MyProfile")
;;;        )
;;;    )
;;;
;;;
;;; - Import a profile and set it active when AutoCAD is first started.
;;;  Place the following code in acaddoc.lsp with the desired ".arg" filename 
;;;  and profile name...
;;;
;;;    (defun s::startup ()
;;;      (if (not (vl-bb-ref ':L12-imported-profile)) ;; have we imported the profile yet?
;;;          (progn
;;;  
;;;            ;; Set a variable on the bulletin-board to indicate that we've been here before.
;;;            (vl-bb-set ':L12-imported-profile T) 
;;;          
;;;            ;; Import the profile and set it active
;;;            (L12-profile-import "c:\\CompanyProfile.arg" "MyProfile" T)
;;;            (L12-profile-set-active "MyProfile")
;;;   
;;;          );progn then
;;;      );if
;;;    );defun s::startup
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This helper function gets the profiles object.
;;
(defun L12-get-profiles-object ( / app pref profs )
 (vl-load-com)
 (and
  (setq   app (vlax-get-acad-object))
  (setq  pref (vla-get-preferences app))
  (setq profs (vla-get-profiles pref))
 )
 profs
);defun L12-get-profiles-object

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Determine if a profile exists. Returns T if the specified profile name exists, and nil if not.
;;
(defun L12-profile-exists ( name / profs )
 (and name
      (setq names (L12-profile-names))
      (member (strcase name) (mapcar 'strcase names))
 )
);defun L12-profile-exists

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the active profile. 
;; NOTES: 
;;  - If the specified profile name is already active then the function returns T and makes no additional 
;;    changes.
;;
;;  - The specified profile must exist. (You can import a profile using the  'L12-profile-import' 
;;    function.) If the specified profile does not exist, the function returns nil.
;;
(defun L12-profile-set-Active ( name / profs )
 (and
  name
  (setq profs (L12-get-profiles-object))
  (or (equal (strcase name) (strcase (getvar "cprofile")))
      (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-put-activeProfile (list profs name))))
  )
 );and
);defun L12-profile-set-Active

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Delete the specified profile. Fails if the specified profile is current.
;; 
(defun L12-profile-delete ( name / profs )
 (and
  name
  (setq profs (L12-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-deleteprofile (list profs name))))
 )
);defun L12-profile-delete
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copy profile.
;;
(defun acad-pref-profile-copy ( source target / profs )
 (and
  source
  target
  (setq profs (L12-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-CopyProfile (list profs source target))))
 )
);defun L12-profile-copy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get a list of profile names
;;
(defun L12-profile-names ( / profs result )
 (and
  (setq profs (L12-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-GetAllProfileNames (list profs 'result))))
  result
  (setq result (vlax-safearray->list result))
 )
 result
);defun L12-profile-names

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rename
;;
(defun L12-profile-rename ( oldName newName / profs )
 (and
  oldName
  newName
  (setq profs (L12-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-RenameProfile (list profs oldName newName))))
 )
);defun L12-profile-rename

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get a unique profile name. This function returns a unique profile name that is guaranteed 
;; to not be present in the current list of profiles.
;;
(defun L12-get-unique-profile-name (sendid / names n name )
 (setq names (L12-profile-names)
       names (mapcar 'strcase names)
        name sendid
           n 1
 )
 (while (member (strcase (setq name (strcat name (itoa n)))) names)
  (setq n (+ n 1))
 )
 name
);defun L12-get-unique-profile-name

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Import
;; This function imports the specified .arg file and creates a new profile with the provided profile name.
;; If the specified profile already exists, it will be overwritten.
;; If the 'bUsePathInfo' parameter is non-nil then path information will be imported from the specified 
;; file. Otherwise, path information will be ignored.
;;
;; NOTES: 
;;  This function does not set the active profile. If you import a new profile 
;;  it will not become active unless it matches the name of the existing active profile. 
;;
;;  You can set the active profile by calling: 
;;    (L12-profile-set-active "ProfileName")
;;
(defun l12-profile-import ( filename profileName bUsePathInfo / L12-oldError profs isCProfile tempProfile result )

 ;; Set up an error handler so, if something goes wrong, we can put things back the way we found them
 (setq L12-oldError *error*)
 (defun *error* ( msg / )
  (if (and profileName
           tempProfile
           (equal tempProfile (getvar "cprofile"))
      )
      (progn
       ;; Something went wrong so put things back the way they were.
       (L12-profile-rename tempProfile profileName)
       (L12-profile-set-active profileName)
       (L12-profile-delete tempProfile)
      );progn then
  );if
  (setq *error* L12-oldError)
  (if msg
      (*error* msg)
      (princ)
  )
 );defun *error*

 (if (and bUsePathInfo
          (not (equal :vlax-false bUsePathInfo))
     )
     (setq bUsePathInfo :vlax-true)
     (setq bUsePathInfo :vlax-false)
 )
 (if (and filename
          (setq filename (findfile filename))
          profileName
          (setq profs (L12-get-profiles-object))
     );and
     (progn
      ;; We can't import directly to the current profile, so if the provided profile name matches 
      ;; the current profile, we'll need to:
      ;;  - rename the current profile to a unique name
      ;;  - import
      ;;  - set the new one current
      ;;  - delete the old one with the temp name
      (setq isCProfile (equal (strcase (getvar "cprofile")) (strcase profileName)))
      (if isCProfile
          (progn
           (setq tempProfile (L12-get-unique-profile-name))
           (L12-profile-rename (getvar "cprofile") tempProfile)
          );progn then
      );if

      ;; Import          
      (setq result (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-ImportProfile (list profs profileName filename bUsePathInfo)))))

      (if isCProfile
          (progn
           ;;  Handle current profile case...
           ;;  If the import was successful, then set the new profile active and delete the original
           ;;  else if something went wrong, then put the old profile back
           (if (and result
                    (setq result (L12-profile-set-Active profileName)) ;; set the newly imported profile active
               );and
               (L12-profile-delete tempProfile)            ;; then delete the old profile
               (L12-profile-rename tempProfile profileName);; else rename the original profile back to its old name
           );if
          );progn then
      );if
     );progn then
 );if

 (*error* nil) ;; quietly restore the original error handler
 result
);defun L12-profile-import

(princ)

(defun L12_GetLastFolder ( path / i j )
(if (eq "" path) path
(progn
(while
(and
(< 0 (setq i (strlen path)))
(member (ascii (substr path i)) '(47 92))
)
(setq path (substr path 1 (1- i)))
)
(while (and (null j) (< 1 i))
(if (member (ascii (substr path (setq i (1- i)))) '(47 92))
(setq j i)
)
)
(if j (substr path (1+ j)) path)
)
)
)

(defun create_updvbs ()

;(vl-file-delete "KT_Temp.vbs")
(setq fname (vl-filename-mktemp "KT_Temp.vbs"))

(setq fn (open fname "w"))

(write-line "Set args = WScript.Arguments
 
'// you can get url via parameter like line below
'//Url = args.Item(0)
Dim oShell : Set oShell = CreateObject(\"WScript.Shell\")
Dim fso : Set fso = CreateObject(\"Scripting.FileSystemObject\")

Dim KTSPathDest, Temp, UserPath, PlotPath, PMPPath, PlotStyles, Plotters, sTemp, iTemp1, Url

Const TemporaryFolder = 2

iTemp1 = 0

bslash = Chr(92)
dblbslash = Chr(92) & Chr(92)

'LabPathSource = (Replace(Wscript.Arguments.Item(0),dblbslash,bslash))
KTSPathDest = (Replace(Wscript.Arguments.Item(0),dblbslash,bslash))
Temp = (Replace(Wscript.Arguments.Item(1),dblbslash,bslash))
" fn)


(write-line "Wscript.Echo \"Downloading sourcefiles\"
'//Download zip from GitHub
dim myPath, a, filename
dim xHttp: Set xHttp = createobject(\"MSXML2.ServerXMLHTTP.3.0\")

Url = Wscript.Arguments.Item(2)

a=split(KTSPathDest,bslash)

filename=a(ubound(a)) & \" .zip \"
filenamebase = a(ubound(a))

myPath = fso.GetSpecialFolder(TemporaryFolder) & bslash & filename 

xHttp.Open \"GET\", Url, False
xHttp.Send

'Wscript.Echo \"Download-Status: \" ^& xHttp.Status ^& \" \" ^& xHttp.statusText
 
If xHttp.Status = 200 Then
    Dim objStream
    set objStream = CreateObject(\"ADODB.Stream\")
    objStream.Type = 1 'adTypeBinary
    objStream.Open
    objStream.Write xHttp.responseBody
    objStream.SaveToFile myPath,2
    objStream.Close
    set objStream = Nothing
End If
set xHttp=Nothing

Wscript.Echo \"Download complete\"

'//Delete existing version

Wscript.Echo \"Deleting existing KTS folder\"
If fso.FolderExists(KTSPathDest) Then 
	Const ReadOnly = 1
	'Set fso = CreateObject(“Scripting.fsotemObject”)
	Set objFolder = fso.GetFolder(KTSPathDest)
	Set colFiles = objFolder.Files
	For Each objFile in colFiles
		If objFile.Attributes AND ReadOnly Then
			objFile.Attributes = objFile.Attributes XOR ReadOnly
		End If
	Next

    fso.DeleteFolder KTSPathDest, True
End If 
" fn)

(write-line "
'//Extract new version
Wscript.Echo \"Extracting file archive-master\"

'The location of the zip file.
ExtractTo=fso.GetSpecialFolder(TemporaryFolder) 
ZipFile=ExtractTo & bslash & filename 

Set objFolder = fso.GetFolder(ExtractTo)
Set colFiles = objFolder.Files
For Each objFile in colFiles
    If objFile.Attributes AND ReadOnly Then
        objFile.Attributes = objFile.Attributes XOR ReadOnly
    End If
Next

ExtractFolder = ExtractTo & bslash & filenamebase & \"-master\"

If fso.FolderExists(ExtractFolder) Then
   fso.DeleteFolder ExtractFolder, True
End If
If fso.FolderExists(ExtractFolder) Then
   fso.DeleteFolder ExtractFolder, True
End If
'If NOT fso.FolderExists(ExtractTo) Then
'   fso.CreateFolder(ExtractTo)
'End If

'Extract the contants of the zip file.
set objShell = CreateObject(\"Shell.Application\")
set FilesInZip = objShell.NameSpace(ZipFile).items
objShell.NameSpace(ExtractTo).CopyHere(FilesInZip)
Set objShell = Nothing

CopySource=fso.GetSpecialFolder(TemporaryFolder)& bslash  & filenamebase & \"-master\" 
CopySourceFiles=fso.GetSpecialFolder(TemporaryFolder)& bslash  & filenamebase & \"-master\" & bslash & \"*.*\"

If NOT fso.FolderExists(KTSPathDest) Then
   fso.CreateFolder(KTSPathDest)
End If

Wscript.Echo \"Copying new version\"
If fso.FolderExists(CopySource) Then 
	
	Copydest = KTSPathDest & bslash
    fso.CopyFolder CopySourceFiles, Copydest 
	fso.CopyFile CopySourceFiles, Copydest
End If
'Parrent = fso.GetParentFolderName(PlotPath) & bslash

Wscript.Echo \"Cleanup installation\"

If fso.FolderExists(ExtractFolder) Then
   fso.DeleteFolder ExtractFolder, True
End If

fso.DeleteFile(fso.GetSpecialFolder(TemporaryFolder) & bslash & filename) 'Deletes the file throught the DeleteFile function

Set fso = Nothing

" fn)

(close fn)

fname

)

(princ)

;support funkties FSO file scripting objects 
(defun stu:DeleteFolder (path / fso)
  (if (and (setq fso (vlax-create-object "Scripting.FilesystemObject"))
           (= -1 (vlax-invoke fso 'folderexists path)))
    (progn
      (vlax-invoke (vlax-invoke fso 'getfolder path) 'delete)
      (vlax-release-object fso)
	)
   )
  (princ)
)

(defun stu:CopyFolder (source target / fso)
  (setq fso (vlax-create-object "Scripting.FilesystemObject"))
  (if (= -1 (vlax-invoke fso 'folderexists source))
    (vlax-invoke fso 'copyfolder source target)
  )
  (vlax-release-object fso)
)

(defun stu:CreateFolder (path / fso)
 (setq fso (vlax-create-object "Scripting.FilesystemObject"))
 (if (not (= -1 (vlax-invoke fso 'folderexists path)))
 (vlax-invoke-method fso 'CreateFolder path))
 (vlax-release-object fso)
 (princ)
)

(defun stu:CopyFile (source target / fso)
(setq fso (vlax-create-object "Scripting.FilesystemObject"))
(vlax-invoke-method fso 'CopyFile source target :vlax-true)
(vlax-release-object fso)
)

(defun setup_wait (seconds / stop)
(setq stop (+ (getvar "DATE") (/ seconds 86400.0)))
(while (> stop (getvar "DATE")))
)
;CODING ENDS HERE