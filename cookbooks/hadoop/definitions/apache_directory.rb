=begin
directory definitions in apache conf files have a few properties we support:
1. they can simply be the directory name as a string
2. they can be a comma-separated list of directories
3. any directory can start with a '$'.  this will reference another conf variable
4. directory names can reference environment vars (e.g. /tmp/hadoop/hadoop-${user.name})
=end
define :apache_directory, :action => :create do
  name = params[:name]
  paths = params.fetch(:path, name)
  paths = paths.split(",")
  
  if params[:action] == :create
    paths.each do |path|
      unless path.start_with?('${') # skip conf variable names
        path = File.dirname(path) if File.basename(path).include?('$')
        directory path do
          mode params.fetch(:mode, "0755")
          recursive params.fetch(:recursive, false)
          owner params[:owner] if params[:owner]
          group params[:group] if params[:group]
          user params[:user] if params[:user]
          action params.fetch(:action)
        end
      end
    end
  end
end