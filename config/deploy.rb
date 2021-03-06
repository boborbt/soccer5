
default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :application, "calcetto"
set :repository,  "ssh://mluser@kdd.di.unito.it/usr/local/GIT/calcetto"
set :branch, "master"
set :deploy_via, :remote_cache

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :deploy_to, "/srv/www/htdocs/#{application}"
set :user, "mongrel"
set :runner, "mongrel"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"


# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :app, "kdd.di.unito.it"
role :web, "kdd.di.unito.it"
role :db,  "kdd.di.unito.it", :primary => true


desc 'Update link to database configuration file'
task :after_update_code do
  run "ln -s #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  run "ln -s #{deploy_to}/#{shared_dir}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml"
  run "chmod u+x #{release_path}/script/hourly.sh"
end


namespace :deploy do
  desc "Restart the mongrel cluster"
  task :restart, :roles => :app do
    run "/etc/init.d/mongrel_cluster restart"
  end
end