=begin
params
  name: package_name defaults to this.
  package_name: package to be installed
  source: location of package. ONLY if installing from local
  repos_url: CRAN repository or mirror to use for installs
  lib: 'lib' option to R's install.packages
  profile: Location of the relevant Unix profile.  If your R package install requires settings
           that are part of a Unix profile other than the user running Chef, then this can be
           helpful to source during the process.
  r_environ: Location of the Renviron file if you think R needs it and it won't otherwise
             be loaded.  this could be common as the user running Chef isn't necessarily
             the user who's environment is being set in R.  For example, running Chef
             as root but installing a package that requires environ settings only done
             for a researcher account.
  r_profile: Location of the Rprofile.  See r_environ for more as to why this is useful
  action: Same as the Chef resource "package"
=end
define :r_package, :action => :install do
  # defaults to :name
  params[:package_name] ||= params[:name]
  
  # installs a package.  currently no support for versions
  if params[:action] == :install
    # if source is specified, then local install.  otherwise, assume from repos
    cmd = if params[:source]
      %{install.packages("#{params[:source]}", repos=NULL, type="source"}
    # if the repos url is passed in, use it
    elsif params[:repos_url]
      %{install.packages("#{params[:package_name]}", repos="#{params[:repos_url]}"}
    # otherwise, just try to install by name only
    else
      %{install.packages("#{params[:package_name]}"}
    end
    # append 'lib' parameter if passed
    cmd = %{#{cmd}, lib="#{params[:lib]}"} if params[:lib]
    cmd = %{#{cmd})} # closing parentheses
    
    script "rstats::r_package::install_package::#{params[:package_name]}" do
      interpreter "bash"
      code <<-EOF
        # source any bash profile stuff that's needed
        #{"source '#{params[:profile]}'" if params[:profile]}
        # set the Renviron if need
        #{"R_ENVIRON_USER='#{params[:r_environ]}'" if params[:r_environ]}
        # set the Rprofile if needed
        #{"R_PROFILE_USER='#{params[:r_profile]}'" if params[:r_profile]}
        R --slave -e '#{cmd}'
        # verify that package is now installed
        if [[ -z $(R --slave -e 'installed.packages()["#{params[:package_name]}","Version"]') ]]
        then
          echo "There appears to be an error installing R package: #{params[:package_name]}"
          exit 1
        fi
      EOF
      # skip step if already installed
      not_if %{R --slave -e 'installed.packages()["#{params[:package_name]}","Version"]'}
    end
  
  # upgrades ALL packages
  elsif params[:action] == :upgrade
    cmd = %{update.packages(ask=F}
    cmd = %{#{cmd}, repos="#{params[:repos_url]}"} if params[:repos_url]
    cmd = %{#{cmd})} # closing parentheses
    
    script "rstats::r_package::update_packages" do
      interpreter "bash"
      code <<-EOF
        R --slave -e '#{cmd}'
      EOF
    end
  
  # removes a package
  # currently no success check...
  elsif params[:action] == :remove
    cmd = %{remove.packages("#{params[:package_name]}"}
    cmd = %{#{cmd}, lib="#{params[:lib]}"} if params[:lib]
    cmd = %{#{cmd})} # closing parentheses
    script "rstats::r_package::remove_package::#{params[:package_name]}" do
      interpreter "bash"
      code <<-EOF
        R --slave -e '#{cmd}'
      EOF
    end
  else
    raise NotImplementedError, "Action #{params[:action]} is not supported."
  end
end