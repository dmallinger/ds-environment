# Settings for hdfs-site.xml

default[:hadoop][:hdfs][:dfs_replication] = "1"
default[:hadoop][:hdfs][:dfs_name_dir] = "/var/hadoop/data/hdfs/name"
default[:hadoop][:hdfs][:dfs_name_edits_dir] = "${dfs.name.dir}"
default[:hadoop][:hdfs][:dfs_data_dir] = "/var/hadoop/data/hdfs/data"
