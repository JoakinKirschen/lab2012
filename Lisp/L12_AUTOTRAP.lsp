(defun c:at ( / incl pt1 pt2 ang1)
(setq incl (getint "1=Optimal -- 2:Manual input -- 3:45� -- 4:10:9"  ))
(setq pt1 (getpoint))
(setq pt2 (getpoint))
(cond
(= incl 1 (setq ang1 (angle pt1 pt2)))
(= incl 2 (setq ang1 (angle pt1 pt2)))
(= incl 3 (setq ang1 (angle pt1 pt2)))
(= incl 4 (setq ang1 (angle pt1 pt2)))
)
)