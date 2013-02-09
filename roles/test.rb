name "test"
description "My test role.  Just changes with whatever I'm testing at the time."
run_list "recipe[rstats]",
         "recipe[rhadoop]"

