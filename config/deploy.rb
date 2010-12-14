set :application, "geocms"
set :repository,  "git@github.com:okouam/geocms.git"
set :scm, :git
set :branch, :v4
set :stages, ["uat", "production"]
require 'capistrano/ext/multistage'
set :default_stage, "test"
set :deploy_via, :remote_cache
set :user, "okouam"
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/home/opt/Rails/apps/geocms/uat"
set :rake, "/var/lib/gems/1.8/bin/rake"

role :web, "xkcd.codeifier.com"
role :app, "xkcd.codeifier.com"
role :db,  "xkcd.codeifier.com", :primary => true

default_run_options[:pty] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
