
;[================================= BnS engineering ===========================]
;
;                                   TO_AMW_TITLE.lsp
; 
; 
;  Herbenoem geselecteerd block naar AMW_TITLE
;
;[=============================================================================]

(defun C:2amw ( / es ed en ans )

  (setq es (entsel "Selecteer Block om te herbenoemen: "))
  (princ "\n")
  (if (= es nil)
    (progn
      (princ "\n Geen block geselecteerd.")
    )
    (progn
      (setq es (car es))
      (setq ed (entget es))
      (setq en (cdr (assoc 2 ed)))
      (setq mess (strcat "\nBlock '" en "' geselecteerd. Herbenoemen ? [Ja/Nee] "))
      (setq ans (getstring mess))
      (if (= "J" (strcase (substr ans 1)))
        (progn
          (command "-RENAME" "B" en "AMW_TITLE")
          (princ (strcat "\nBlock '" en "' is herbenoemd."))
        )
      )
    )
  ) 
  (princ)
)