##
# java
##

# if the install or cache_path directories don't exist, make them now
directory node[:java][:install_path] do
  mode "0775"
  recursive true
  owner node[:java][:owner] if node[:java][:owner]
  group node[:java][:group] if node[:java][:group]
  action :create
end

directory node[:java][:remote_file_path] do
  mode "0775"
  recursive true
  owner node[:java][:owner] if node[:java][:owner]
  group node[:java][:group] if node[:java][:group]
  action :create
end

# java comes with mac os x, just need to make sure that JAVA_HOME is set
# TODO: this is another place where, in the future, we need more OS support
script "java::configure_java" do
  interpreter "bash"
  code <<-EOF
    echo "export JAVA_HOME=\\$(/usr/libexec/java_home)" >> #{node[:java][:profile_path]}
  EOF
  not_if "grep JAVA_HOME #{node[:java][:profile_path]}"
end


##
# ant
##

tarball_package "java::apache_ant" do
  source node[:ant][:url]
  checksum node[:ant][:checksum]
  path "#{node[:java][:install_path]}/apache-ant-#{node[:ant][:version]}"
  cache_path "#{node[:java][:remote_file_path]}/apache-ant-#{node[:ant][:version]}.tar.gz"
  profile "#{node[:java][:profile_path]}"
  softlink "#{node[:java][:install_path]}/ant"
  environment_var "ANT_HOME"
  owner node[:java][:owner] if node[:java][:owner]
  group node[:java][:group] if node[:java][:group]
  action :create
end

##
# maven
##

tarball_package "java::apache_maven" do
  source node[:maven][:url]
  checksum node[:maven][:checksum]
  path "#{node[:java][:install_path]}/apache-maven-#{node[:maven][:version]}"
  cache_path "#{node[:java][:remote_file_path]}/apache-maven-#{node[:maven][:version]}.tar.gz"
  profile "#{node[:java][:profile_path]}"
  softlink "#{node[:java][:install_path]}/maven"
  environment_var "MAVEN_HOME"
  owner node[:java][:owner] if node[:java][:owner]
  group node[:java][:group] if node[:java][:group]
  action :create
end

