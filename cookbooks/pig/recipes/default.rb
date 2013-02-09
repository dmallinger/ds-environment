##
# dependencies
##

include_recipe "hadoop"

##
# install the pig source
##

tarball_package "pig::pig" do
  source node[:pig][:url]
  checksum node[:pig][:checksum]
  path "#{node[:hadoop][:install_path]}/pig-#{node[:pig][:version]}"
  cache_path "#{node[:hadoop][:remote_file_path]}/pig-#{node[:pig][:version]}.tar.gz"
  profile "#{node[:hadoop][:profile_path]}"
  softlink "#{node[:hadoop][:install_path]}/pig"
  environment_var "PIG_HOME"
  owner node[:hadoop][:owner] if node[:hadoop][:owner]
  group node[:hadoop][:group] if node[:hadoop][:group]
  action :create
end

