# General and non-config file stuff should go here.

default[:hadoop][:install_path] = "/usr/local"
default[:hadoop][:remote_file_path] = "/tmp"
default[:hadoop][:profile_path] = "/etc/profile"
default[:hadoop][:owner] = nil
default[:hadoop][:group] = nil

default[:hadoop][:url] = "http://archive.cloudera.com/cdh/3/hadoop-0.20.2-cdh3u5.tar.gz"
default[:hadoop][:checksum] = "70001638f8ada92d94c1a11a4b025f7dc3fede72b6cedc3e2b9f316b6e8c161a"
default[:hadoop][:version] = "0.20.2-cdh3u5"
