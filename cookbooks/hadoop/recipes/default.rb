##
# dependencies
##

include_recipe "java"

# ensure the install and cache paths exist
directory node[:hadoop][:install_path] do
  mode "0775"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

directory node[:hadoop][:remote_file_path] do
  mode "0775"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

##
# install the hadoop source
##

tarball_package "hadoop::hadoop_core" do
  source node[:hadoop][:url]
  checksum node[:hadoop][:checksum]
  path "#{node[:hadoop][:install_path]}/hadoop-#{node[:hadoop][:version]}"
  cache_path "#{node[:hadoop][:remote_file_path]}/hadoop-#{node[:hadoop][:version]}.tar.gz"
  profile "#{node[:hadoop][:profile_path]}"
  softlink "#{node[:hadoop][:install_path]}/hadoop"
  environment_var "HADOOP_HOME"
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end


##
# required hadoop tmp directory
##

apache_directory "hadoop::core::hadoop_tmp_dir" do
  path node[:hadoop][:core][:hadoop_tmp_dir]
  mode "0777"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

##
# required log directory
##

directory "hadoop::core::hadoop_log_dir" do
  path node[:hadoop][:env][:hadoop_log_dir]
  mode "0777"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

##
# required pid directory
##

# pid dir should not be 777 in prod, but we're being lazy for the moment
# UPDATE: owner/group should fix this but untested/fixed
directory "hadoop::core::hadoop_pid_dir" do
  path node[:hadoop][:env][:hadoop_pid_dir]
  mode "0777"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

##
# configuration files
##

# ensure the conf dir exists
directory node[:hadoop][:env][:hadoop_conf_dir] do
  mode "0775"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

# create files from templates
%w{capacity-scheduler.xml core-site.xml fair-scheduler.xml 
   hadoop-env.sh hadoop-metrics.properties hadoop-policy.xml
   hdfs-site.xml log4j.properties mapred-site.xml masters
   slaves}.each do |tmpl|
  template "#{node[:hadoop][:env][:hadoop_conf_dir]}/#{tmpl}" do
    mode "0644"
    source "conf/#{tmpl}.erb"
    owner node[:hadoop][:owner] if node[:hadoop][:owner]
    group node[:hadoop][:group] if node[:hadoop][:group]
  end
end

# hadoop-env.sh needs to be executable
file "#{node[:hadoop][:env][:hadoop_conf_dir]}/hadoop-env.sh" do
  mode "0755"
  action :touch
end
