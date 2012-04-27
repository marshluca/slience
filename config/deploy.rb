set :application, "marshluca"
set :repository,  "git@github.com:marshluca/slience.git"

set :branch, "master"
set :deploy_to, "/home/marshluca/#{application}"

set :use_sudo, false
set :user, "slience"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_via, :remote_cache
set :app_server, :passenger
set :domain, "174.143.247.66"

role :web, domain                         # Your HTTP server, Apache/etc
role :app, domain                         # This may be the same as your `Web` server
role :db,  domain, :primary => true       # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    run "ln -nfs #{File.join(shared_path,'/mongoid.yml.emrms')} #{File.join(release_path,'config','mongoid.yml')}"
  end
  
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --deployment"
  end

  task :bundle_new_release, :roles => :db do
    bundler.create_symlink
    bundler.install
  end
end

after "deploy:update_code", "bundler:bundle_new_release"
