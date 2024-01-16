
(defun c:txt70 ()

  (setvar "cmdecho" 0)
  (setq c1 (getvar "clayer"))
  (setq pt1 (getpoint "  Duid plaats van tekst aan :"))
  (princ "\n ")
  (setq hoogte (* schaal 7.0))
  (setq x1 (car pt1))
  (setq y1 (cadr pt1))
  (command "layer" "s" "TXT70" "")
  (command "dtext" (list x1 y1) hoogte 0)
  (setvar "cmdecho" 1)
  (command "layer" "s" c1 "")
  (princ)

)
