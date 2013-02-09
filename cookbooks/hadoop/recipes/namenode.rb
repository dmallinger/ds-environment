# initialize
include_recipe "hadoop"

# ensure the namenode directories exist
%w{dfs_name_dir dfs_name_edits_dir}.each do |flag|
  apache_directory "hadoop::hdfs::#{flag}" do
    path node[:hadoop][:hdfs][flag.to_sym]
    mode "0777"
    recursive true
    owner node[:hadoop][:owner] if node[:hadoop][:owner]
    group node[:hadoop][:group] if node[:hadoop][:group]
    action :create
  end  
end
