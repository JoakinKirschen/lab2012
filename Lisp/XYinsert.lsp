
;* **************************************************************************
;* *************************  BnS engineering nv. - Zelzate  ****************
;* *************************  BnS informatica                ****************
;* **************************************************************************
;*
;* MODULE             : XYinsert.LSP
;* DATUM              : 26/04/06 Debugged 30/02/'10 By Joakin Kirschen
;*
;* **************************************************************************

;* **************************************************************************
;* Globale instellingen:
;* 
;* naam van te inserteren symbool:  

   (setq smbName "X-Y Coordinaat")

;* **************************************************************************
;* *************************** Public functions *****************************
;* **************************************************************************

;* **************************************************************************

(defun C:WONZ ( / ip factor ipX ipY strIPx strIPy savedAttReq SavedAttDia smb rotatie )
  (initerr)
  (setq factor (L12_getschaal))
  (setvar "luprec" 0)
  (setq smb (GetSymbolName))
  (if (/= smb nil)
    (progn
      (setq ip (getpoint "Insertiepunt: "))
      (if (/= ip nil)
        (progn
          (setq ipX (car  ip)
                ipy (cadr ip)
          )
          (if (> ipx 0)
            (progn
;             (setq strIPx (strcat "O=" (substr (Dec3 (rtos (/ ipX 1000))) 2)))
              (setq strIPx (strcat "O=" (MetDuizendPunt (rtos ipX))))
              (if (> ipy 0)
                (progn
                  ;* NO
;                 (setq strIPy (strcat "N=" (substr (Dec3 (rtos (/ ipY 1000))) 2)))
                  (setq strIPy (strcat "N=" (MetDuizendPunt (rtos ipY))))
                )
                (progn
                  ;* ZO
;                  (setq strIPy (strcat "Z=" (substr (Dec3 (rtos (abs (/ ipY 1000)))) 2)))
                  (setq strIPy (strcat "Z=" (MetDuizendPunt (substr (rtos ipY) 2))))
                )
              )
            )
            (progn
;             (setq strIPx (strcat "W=" (substr (Dec3 (rtos (abs (/ ipX 1000)))) 2)))
              (setq strIPx (strcat "W=" (MetDuizendPunt (substr (rtos ipX) 2))))
              (if (> ipy 0)
                (progn
                  ;* NW
                  (setq strIPy (strcat "N=" (substr (Dec3 (rtos (/ ipY 1000))) 2)))
                  (setq strIPy (strcat "N=" (MetDuizendPunt (rtos ipY))))
                )
                (progn
                  ;* ZW
;                 (setq strIPy (strcat "Z=" (substr (Dec3 (rtos (abs (/ ipY 1000)))) 2)))
                  (setq strIPy (strcat "Z=" (MetDuizendPunt (substr (rtos ipY) 2))))
                )
              )
            )
          )
	  (princ (strcat "\n " strIPX " en " strIPY "\n"))
          (setq savedAttReq (getvar "ATTREQ"))
          (setq SavedAttDia (getvar "ATTDIA"))
          (setvar "ATTDIA" 0)
          (setvar "ATTREQ" 1)
	  (setq rotatie (/ (/ (* (atan (cadr (getvar "UCSXDIR")) (car (getvar "UCSXDIR"))) 180) PI) -1))
	  (command "insert" smb ip factor factor rotatie strIPY strIPX)
          (setvar "ATTREQ" savedAttReq)
          (setvar "ATTDIA" SavedAttDia)
	 )
      )
    )
    (progn
      (princ (strcat "\n FOUT: Kan symbool " smbName " niet vinden"))
    )	 
  )
  (reset)
  (princ)
)
;* **************************************************************************

(defun C:XY ( / ip ipX ipY savedAttReq SavedAttDia smb rotatie )
  (initerr)
  (setq factor (L12_getschaal))
  (setvar "luprec" 0)
  (setq smb (GetSymbolName))
  (if (/= smb nil)
    (progn
      (setq ip (getpoint "Insertiepunt: "))
      (if (/= ip nil)
        (progn
;         (setq ipX (strcat "X=" (Dec3 (rtos (/ (car  ip) 1000))))
;               ipY (strcat "Y=" (Dec3 (rtos (/ (cadr ip) 1000))))
;         )
          (setq ipX (strcat "X=" (MetDuizendPunt (rtos (car  ip))))
                ipY (strcat "Y=" (MetDuizendPunt (rtos (cadr ip))))
          )
	  (princ (strcat "\n " ipX " en " ipY "\n"))
          (setq savedAttReq (getvar "ATTREQ"))
          (setq SavedAttDia (getvar "ATTDIA"))
          (setvar "ATTDIA" 0)
          (setvar "ATTREQ" 1)
	  (setq rotatie (/ (/ (* (atan (cadr (getvar "UCSXDIR")) (car (getvar "UCSXDIR"))) 180) PI) -1))
          (command "insert" smb ip factor factor rotatie  ipX ipY)
          (setvar "ATTREQ" savedAttReq)
          (setvar "ATTDIA" SavedAttDia)
	 )
      )
    )
    (progn
      (princ (strcat "\n FOUT: Kan symbool " smbName " niet vinden"))
    )	 
  )
  (princ)
  (reset)
)

;* **************************************************************************

;* **************************************************************************
;* *************************** Local functions ******************************
;* **************************************************************************
;* getal (string) zonder cijfers na de komma (zonder afronding)

(defun noDec  ( strGetal / strNoDec )

  (setq strNoDec  "")
  (setq i 1)
  (while (<= i (strlen strgetal))
    (if (= (substr strgetal i 1) ".")
      (progn
        (setq i (1+ (strlen strgetal)))
      )
      (progn
        (setq strNoDec (strcat strNoDec (substr strgetal i 1)))
        (setq i (1+ i))
      )
    )
  )
  strNoDec
) 


;* **************************************************************************

(defun MetDuizendPunt ( strGetal / strMetPunt i p)

  (setq i (strlen strGetal))
  (if (<= i 3)
    (progn
      (setq strMetPunt strGetal)
    )
    (progn
      (if (<= 6)
        (progn
          (setq strMetPunt (strcat (substr strGetal 1 (- i 3)) 
                                   "." 
                                   (substr strGetal (- i 2) 3)
                           )
          )
        )
        (progn
          (setq strMetPunt (strcat (substr strGetal 1 (- i 6)) 
                                   "." 
                                   (substr strGetal (- i 5) 3)
                                   "." 
                                   (substr strGetal (- i 2) 3)
                           )
          )
        )
      )
    )
  )
  strMetPunt
)

;* **************************************************************************

(defun Dec3  ( strGetal / strNoDec strRest i gevonden )

  (setq strNoDec  "")
  (setq i 1)
  (while (<= i (strlen strGetal))
    (if (= (substr strGetal i 1) ".")
      (progn
        (setq strRest (substr (strcat strGetal "000") (1+ i) 3))
        (setq strNoDec (strcat strnodec "." strRest))
        (setq i (1+ (strlen strgetal)))
      )
      (progn
        (setq strNoDec (strcat strNoDec (substr strgetal i 1)))
        (setq i (1+ i))
      )
    )
  )
  (setq i 1
        gevonden nil
  )
  (while (<= i (strlen strnodec ))
    (if (= (substr strnodec i 1) ".")(setq gevonden T))
    (setq i (1+ i))
  )
  (if (= gevonden nil) (setq strNoDec (strcat strNodec ".000")))
  (if (> (atof strNoDec) 0) (setq strNoDec (strcat "+" strNoDec)))
  strNoDec
) 

;* **************************************************************************

(defun GetSymbolName ( / smb )

  (if (/= (tblsearch "BLOCK" smbName) nil)
    (progn
      (setq smb smbName)
    )
    (progn
      (setq smb (findfile (strcat smbName ".dwg")))
    )
  )
   smb
)

;* **************************************************************************

(princ "\nBeschikbare commando's: XY of WONZ")
(princ)