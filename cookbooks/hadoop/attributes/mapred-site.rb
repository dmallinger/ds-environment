# Settings for mapred-site.xml

default[:hadoop][:mapred][:mapred_job_tracker] = "localhost:8021"
default[:hadoop][:mapred][:mapred_tasktracker_map_tasks_maximum] = "2"
default[:hadoop][:mapred][:mapred_tasktracker_reduce_tasks_maximum] = "2"
default[:hadoop][:mapred][:mapred_local_dir] = "/var/hadoop/data/mapred/local"

