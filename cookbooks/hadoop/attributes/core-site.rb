# Settings for core-site.xml

default[:hadoop][:core][:hadoop_tmp_dir] = "/tmp/hadoop/hadoop-${user.name}"
default[:hadoop][:core][:fs_default_name] = "hdfs://localhost:8020"
default[:hadoop][:core][:fs_checkpoint_dir] = "/var/hadoop/data/hdfs/checkpoint"
default[:hadoop][:core][:fs_checkpoint_edits_dir] = "${fs.checkpoint.dir}"
