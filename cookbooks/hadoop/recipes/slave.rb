# initialize
include_recipe "hadoop"

# hdfs data directories
apache_directory "hadoop::hdfs::dfs_data_dir" do
  path node[:hadoop][:hdfs][:dfs_data_dir]
  mode "0777"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

# local tasktracker directories
apache_directory "hadoop::mapred::mapred_local_dir" do
  path node[:hadoop][:mapred][:mapred_local_dir]
  mode "0777"
  recursive true
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end