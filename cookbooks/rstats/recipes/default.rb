##
# rstats
##

# download the R package (keep it in our remote_file_path for future runs)
remote_file "rstats::base::download_rstats" do
  source node[:rstats][:url]
  path "#{node[:rstats][:remote_file_path]}/R-#{node[:rstats][:version]}.pkg"
  checksum node[:rstats][:checksum]
  mode "0644"
end

# install the R base package
# TODO this is Mac OS X only, we should find a more friendly package installation
script "rstats::base::install_rstats" do
  interpreter "bash"
  code <<-EOF
    installer -pkg #{node[:rstats][:remote_file_path]}/R-#{node[:rstats][:version]}.pkg -target #{node[:rstats][:install_volume]}
  EOF
  user "root" # has to be root on mac
  # skip it if the correct version is installed
  not_if { `R --version`.gsub(/.*?R version (\d+\.\d+\.\d+).*$/m, '\1') == node[:rstats][:version] }
end

# set our repo in the profile
script "rstats::base::select_repo" do
  interpreter "bash"
  code <<-EOF
  echo '
local({ r <- getOption("repos")
  r["CRAN"] <- "#{node[:rstats][:repos_url]}"
  options(repos=r)
})' >> #{node[:rstats][:r_profile_path]}
  EOF
  only_if { node[:rstats][:r_profile_path] }
end

r_package "rstats::base::update_packages" do
  repos_url node[:rstats][:repos_url]
  action :upgrade
end

# now install any custom packages
node[:rstats][:packages].each do |package|
  r_package "rstats::base::install_package::#{package}" do
    package_name package
    repos_url node[:rstats][:repos_url]
    action :install
  end
end
