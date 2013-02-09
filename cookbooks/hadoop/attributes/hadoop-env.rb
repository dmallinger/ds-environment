# Settings for hadoop-env.sh

default[:hadoop][:env][:hadoop_conf_dir] = "/usr/local/hadoop/conf"
default[:hadoop][:env][:hadoop_log_dir] = "/usr/local/hadoop/logs"
default[:hadoop][:env][:hadoop_heapsize] = 2048
default[:hadoop][:env][:hadoop_pid_dir] = "/var/hadoop/pids"
# Mac OS X fix
default[:hadoop][:env][:hadoop_opts] = "-Djava.security.krb5.realm=OX.AC.UK -Djava.security.krb5.kdc=kdc0.ox.ac.uk:kdc1.ox.ac.uk"