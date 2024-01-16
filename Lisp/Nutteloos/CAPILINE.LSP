(defun c:capiline(/ p1 p2 x1 x)
		(command ".insert" "capi" "0,0" "1" "1" "0")
		(command ".erase" "0,0" "")
	        (setvar "cmdecho" 0)
                (command "layer" "s" "contin2" "")
		(initget 1)
		(setq p1 (getpoint "\nGeef startpunt:"))
		(setq p2 T)
		(while p2
		(setq p2 (getpoint p1"\nGeef volgend punt:"))
		(if p2 (progn
		(setq x1 (distance p1 p2))
                (setq x (fix x1))
                (setq x (/ x 10))
                (setq i (fix x))
                (if (>= (rem x 1) 0.5)(setq i (+i 1)))
                (command ".line" p1 p2 "")
                (command ".divide" p1 "b" "capi" "y" i)
		(setq p1 p2)
		)); progn if
		) ; while
		(setvar "cmdecho" 1)
)

