name "local"
description "The role for a local DS environment"
run_list "recipe[hadoop::namenode]", 
         "recipe[hadoop::secondary_namenode]", 
         "recipe[hadoop::jobtracker]", 
         "recipe[hadoop::slave]", 
         "recipe[hive]", 
         "recipe[pig]",
         "recipe[rstats]",
         "recipe[rhadoop]"
