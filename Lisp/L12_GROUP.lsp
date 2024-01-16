;;-----[ Deze functie altijd laten staan]------------------------------------
(defun L12_GROUP ()
(princ "L12_GROUP is loaded")
(princ)
)

(defun c:grp ( / l )
  (vl-load-com)
  ;; © Lee Mac 2010

  (or *doc (setq *doc (vla-get-ActiveDocument (vlax-get-acad-object))))

  (if (setq l (LM:SS->VLA (ssget)))
    (vla-AppendItems
      (vla-Add (vla-get-Groups *doc) "*")
      (LM:ObjectVariant l)
    )
  )
  (princ)
)

(defun c:ugrp ( / group g h lst )
  (vl-load-com)
  ;; © Lee Mac 2010

  (or *doc (setq *doc (vla-get-ActiveDocument (vlax-get-acad-object))))
  
  (vlax-for group (vla-get-Groups *doc)
    (vlax-for object group
      (setq g (cons (vla-get-Handle object) g))
    )
    (setq lst (cons (cons group g) lst) g nil)
  )

  (if lst
    (while
      (progn
        (setq e (car (entsel "\nSelect object from group: ")))

        (cond
          (
            (eq 'ENAME (type e)) (setq h (vla-get-Handle (vlax-ename->vla-object e)))

            (if
              (setq group
                (vl-some
                  (function
                    (lambda ( g )
                      (if (vl-position h (cdr g)) g)
                    )
                  )
                  lst
                )
              )
              (progn
                (vla-delete (car group))
                (setq lst (vl-remove group lst))
                (princ "\n** Group Deleted **")
              )
              (princ "\n** Object is not a member of a group **")
            )
          )
        )
      )
    )
    (princ "\n** No Groups in Drawing **")
  )
  (princ)
)  

;;------------------=={ Safearray Variant }==-----------------;;
;;                                                            ;;
;;  Creates a populated Safearray Variant of a specified      ;;
;;  data type                                                 ;;
;;------------------------------------------------------------;;
;;  Author: Lee McDonnell, 2010                               ;;
;;                                                            ;;
;;  Copyright © 2010 by Lee McDonnell, All Rights Reserved.   ;;
;;  Contact: Lee Mac @ TheSwamp.org, CADTutor.net             ;;
;;------------------------------------------------------------;;
;;  Arguments:                                                ;;
;;  datatype - variant type enum (eg vlax-vbDouble)           ;;
;;  data     - list of static type data                       ;;
;;------------------------------------------------------------;;
;;  Returns:  VLA Variant Object of type specified            ;;
;;------------------------------------------------------------;;

(defun LM:SafearrayVariant ( datatype data )
  ;; © Lee Mac 2010
  (vlax-make-variant
    (vlax-safearray-fill
      (vlax-make-safearray datatype
        (cons 0 (1- (length data)))
      )
      data
    )    
  )
)

;;-------------------=={ Object Variant }==-------------------;;
;;                                                            ;;
;;  Creates a populated Object Variant                        ;;
;;------------------------------------------------------------;;
;;  Author: Lee McDonnell, 2010                               ;;
;;                                                            ;;
;;  Copyright © 2010 by Lee McDonnell, All Rights Reserved.   ;;
;;  Contact: Lee Mac @ TheSwamp.org, CADTutor.net             ;;
;;------------------------------------------------------------;;
;;  Arguments:                                                ;;
;;  lst - list of VLA Objects to populate the Variant.        ;;
;;------------------------------------------------------------;;
;;  Returns:  VLA Object Variant                              ;;
;;------------------------------------------------------------;;

(defun LM:ObjectVariant ( lst )
  ;; © Lee Mac 2010
  (LM:SafearrayVariant vlax-vbobject lst)
)

;;-----------------=={ SelectionSet -> VLA }==----------------;;
;;                                                            ;;
;;  Converts a SelectionSet to a list of VLA Objects          ;;
;;------------------------------------------------------------;;
;;  Author: Lee McDonnell, 2010                               ;;
;;                                                            ;;
;;  Copyright © 2010 by Lee McDonnell, All Rights Reserved.   ;;
;;  Contact: Lee Mac @ TheSwamp.org, CADTutor.net             ;;
;;------------------------------------------------------------;;
;;  Arguments:                                                ;;
;;  ss - Valid SelectionSet (Pickset)                         ;;
;;------------------------------------------------------------;;
;;  Returns:  List of VLA Objects                             ;;
;;------------------------------------------------------------;;

(defun LM:ss->vla ( ss )
  ;; © Lee Mac 2010
  (if ss
    (
      (lambda ( i / e l )
        (while (setq e (ssname ss (setq i (1+ i))))
          (setq l (cons (vlax-ename->vla-object e) l))
        )
        l
      )
      -1
    )
  )
)