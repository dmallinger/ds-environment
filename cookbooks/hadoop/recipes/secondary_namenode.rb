# initialize
include_recipe "hadoop"

# ensure the checkpoint directories exist
%w{fs_checkpoint_dir fs_checkpoint_edits_dir}.each do |flag|
  apache_directory "hadoop::core::#{flag}" do
    path node[:hadoop][:core][flag.to_sym]
    mode "0777"
    recursive true
    owner node[:hadoop][:owner] if node[:hadoop][:owner]
    group node[:hadoop][:group] if node[:hadoop][:group]
    action :create
  end  
end
