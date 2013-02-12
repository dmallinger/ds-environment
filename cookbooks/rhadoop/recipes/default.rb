##
# dependencies
##

include_recipe "rstats"

##
# R dependencies
##

%w{rJava Rcpp RJSONIO digest functional stringr plyr}.each do |package|
  r_package "rhadoop::base::install_package::#{package}" do
    package_name package
    repos_url node[:rstats][:repos_url]
    action :install
  end
end

##
# Ensure that the necessary Hadoop environment variable are set
##

# RHadoop requires that HADOOP_CMD and HADOOP_STREAMING are set.  We can separate
# RHadoop logic from the rest of our Hadoop stuff by setting it in the Renviron.
# If this variable is set, we'll do it there.
script "rhadoop::base::r_environ" do
  interpreter "bash"
  code <<-EOF
    # remove the old declarations
    grep -v 'HADOOP_CMD=' #{node[:rstats][:r_environ_path]} > #{node[:rstats][:r_environ_path]}.tmp
    grep -v 'HADOOP_STREAMING=' #{node[:rstats][:r_environ_path]}.tmp > #{node[:rstats][:r_environ_path]}
    # clean up our temp file
    rm #{node[:rstats][:r_environ_path]}.tmp
    # source the profile, we'll need those environment variables
    source "#{node[:hadoop][:profile_path]}"
    # update declarations
    echo "HADOOP_CMD=$HADOOP_HOME/bin/hadoop" >> #{node[:rstats][:r_environ_path]}
    echo "HADOOP_STREAMING=$HADOOP_HOME/contrib/streaming/hadoop-streaming-#{node[:hadoop][:version]}.jar" >> #{node[:rstats][:r_environ_path]}
  EOF
  action :run
  only_if { node[:rstats][:r_environ_path] }
end

# Install rhdfs
remote_file "rhadoop::base::download_rhdfs" do
  source node[:rhadoop][:rhdfs][:url]
  path "#{node[:rstats][:remote_file_path]}/rhdfs-#{node[:rhadoop][:rhdfs][:version]}.tar.gz"
  checksum node[:rhadoop][:rhdfs][:checksum]
  mode "0644"
end

r_package "rhadoop::base::install_rhdfs" do
  package_name "rhdfs"
  source "#{node[:rstats][:remote_file_path]}/rhdfs-#{node[:rhadoop][:rhdfs][:version]}.tar.gz"
  r_environ node[:rstats][:r_environ_path] # requires the hadoop environment vars
  action :install
end

# Install rmr2
remote_file "rhadoop::base::download_rmr" do
  source node[:rhadoop][:rmr2][:url]
  path "#{node[:rstats][:remote_file_path]}/rmr2-#{node[:rhadoop][:rmr2][:version]}.tar.gz"
  checksum node[:rhadoop][:rmr2][:checksum]
  mode "0644"
end

r_package "rhadoop::base::install_rmr" do
  package_name "rmr2"
  source "#{node[:rstats][:remote_file_path]}/rmr2-#{node[:rhadoop][:rmr2][:version]}.tar.gz"
  action :install
end
