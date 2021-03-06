require "bundler/capistrano"


# Load RVM's capistrano plugin.    
require "rvm/capistrano"
# load 'deploy/assets'

set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user  # Don't use system-wide RVM


server "54.248.232.184", :web, :app, :db, primary: true

set :application, "artist"
set :user, "deployer"
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:zben/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} passenger server"
    task command, roles: :app, except: {no_release: true} do
      run "#{sudo} /etc/init.d/nginx #{command}"
    end
  end
end

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
  # task :setup_config, roles: :app do
  #   sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
  #   sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  #   run "mkdir -p #{shared_path}/config"
  #   put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
  #   puts "Now edit the config files in #{shared_path}."
  # end
  # after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/constants.rb #{release_path}/config/initializers/constants.rb"
  end
end
after "deploy:finalize_update", "deploy:symlink_config"

namespace :web do
  task :disable, :roles => :web do
    on_rollback { run "rm #{shared_path}/system/maintenance.html" }
    run "if [[ !(-f #{shared_path}/system/maintenance.html) ]] ; then ln -s #{shared_path}/system/maintenance.html.not_active #{shared_path}/system/maintenance.html ; else echo 'maintenance page already up'; fi"
  end
  task :enable, :roles => :web do
    run "rm #{shared_path}/system/maintenance.html"
  end
end
