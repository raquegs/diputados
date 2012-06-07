require "bundler/capistrano"

# RVM Setup

set :rvm_ruby_string, "1.9.3"
set :rvm_type, :system  # Copy the exact line. I really mean :system here

require "rvm/capistrano"

set :application, "diputados"
set :repository,  "https://github.com/BlueLemon/diputados.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/diputados"

role :web, "diputados"                          # Your HTTP server, Apache/etc
role :app, "diputados"                          # This may be the same as your `Web` server
role :db,  "diputados", :primary => true        # This is where Rails migrations will run

set :user, "diputados"

set :use_sudo, false

namespace :deploy do

  namespace :db do

    desc <<-DESC
      [internal] Updates the symlink for database.yml file to the just deployed release.
    DESC
    task :symlink, :except => { :no_release => true }, :role => :app do
      run "ln -fs ~/database.yml #{release_path}/config/database.yml"
    end

  end

end

after "deploy:finalize_update", "deploy:db:symlink"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
