=begin
given a tarball location, will download said file, untar it, and place it
a defined location
parameters:
  source: where the tarball can be downloaded
  checksum: checksum of the tarball
  path: location for the new directory
  cache_path: location for chef to cache downloaded files
  profile: location of profile or rc file
  softlink: if set, create a softlink here for the created directory
  environment_var: if set, the name of an environment variable to set to the /bin dir
=end
define :tarball_package, :action => :create do
  if params[:cache_path].nil? || params[:cache_path].empty?
    params[:cache_path] = "/tmp/#{File.basename(params[:source])}"
  end
  
  if params[:action] == :create
    # download the tarball
    remote_file "tarball_package::download_source::#{params[:name]}" do
      source params[:source]
      path "#{params[:cache_path]}"
      checksum params[:checksum] if params[:checksum]
      mode "0644"
      owner params[:owner] if params[:owner]
      group params[:group] if params[:group]
      user params[:user] if params[:user]
      notifies :run, "script[tarball_package::untar::#{params[:name]}]", :immediately
    end

    # untar the file and move to the specified path.
    #
    # notice the conditional value for action.  this ensures that
    # we run the script if the directory doesn't exist (e.g. if
    # a user accidentally deleted it).  we don't use not_if/only_if
    # because these block the notification from remote_file, above,
    # which is necessary if the remote file is updated and thus
    # the checksum changes.
    script "tarball_package::untar::#{params[:name]}" do
      interpreter "bash"
      cwd "/tmp"
      code <<-EOF
        rm -rf #{params[:path]}
        tar xzf #{params[:cache_path]}
        mv #{File.basename(params[:cache_path], ".tar.gz")} #{params[:path]}
      EOF
      user params[:user] if params[:user]
      action File.exists?(params[:path]) ? :nothing : :run
    end
    
    # ensure recursive ownership of the new directory and contents
    if params[:owner] || params[:group]
      execute "tarball_package::chown::#{params[:name]}" do
        command "chown -R #{params[:owner]}:#{params[:group]} #{params[:path]}"
        user params[:user] if params[:user]
        action :run
      end
    end
    
    # remove the old softlink if one is defined
    # (this lazily assumes any definition is a change)
    file "tarball_package::softlink_delete::#{params[:name]}" do
      path params[:softlink]
      user params[:user] if params[:user]
      action :delete
      only_if { params[:softlink] }
    end
    
    # optionally, create a softlink
    script "tarball_package::softlink::#{params[:name]}" do
      interpreter "bash"
      code <<-EOF
        ln -s #{params[:path]} #{params[:softlink]}
      EOF
      user params[:user] if params[:user]
      action :run
      only_if { params[:softlink] }
    end
    
    # ensure the softlink is owned by the right person
    file "tarball_package::softlink_owner::#{params[:name]}" do
      path params[:softlink]
      owner params[:owner] if params[:owner]
      group params[:group] if params[:group]
      action :touch
    end
    
    # optionally, create an environment variable and add {path}/bin to PATH
    # note grep to remove old references. that code is lazy and might "over-prune".
    # also note grep, not sed, because of stupid Mac OS X implementation of word
    # boundaries in sed... ugh
    script "tarball_package::environment::#{params[:name]}" do
      interpreter "bash"
      code <<-EOF
        grep -v -P '\\b#{params[:environment_var]}\\b' #{params[:profile]} > #{params[:profile]}.tmp
        cat #{params[:profile]}.tmp > #{params[:profile]}
        rm #{params[:profile]}.tmp
        echo "export #{params[:environment_var]}=#{params[:path]}" >> #{params[:profile]}
        echo "export PATH=\\$PATH:\\$#{params[:environment_var]}/bin" >> #{params[:profile]}
      EOF
      user params[:user] if params[:user]
      action :run
      only_if { params[:environment_var] }
    end
  end
end