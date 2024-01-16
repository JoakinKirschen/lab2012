
(defun MAAKLIJST (fp / regel)
  
  (setq	regel (read-line fp) ;first line is a label for file
	DLIST NIL
  )

  (while regel ;process each line of file
    (setq dlist	(append dlist (list regel))
	  regel	(read-line fp)
    ) 
  ) 
  (print dlist)
)   ;defun maaklijst
