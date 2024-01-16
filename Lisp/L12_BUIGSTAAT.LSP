(defun C:Buigstaat ( / )
  (command "-attext" "E" "all" "" "sdf" (findfile "BuigstaatTemplate.txt") "t:/buigstaat.txt")
)
