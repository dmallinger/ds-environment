##
# dependencies
##

include_recipe "hadoop"

##
# install the hive source
##

tarball_package "hive::hive" do
  source node[:hive][:url]
  checksum node[:hive][:checksum]
  path "#{node[:hadoop][:install_path]}/hive-#{node[:hive][:version]}"
  cache_path "#{node[:hadoop][:remote_file_path]}/hive-#{node[:hive][:version]}.tar.gz"
  profile "#{node[:hadoop][:profile_path]}"
  softlink "#{node[:hadoop][:install_path]}/hive"
  environment_var "HIVE_HOME"
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

