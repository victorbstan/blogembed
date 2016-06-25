set :application,       "blogembed"
set :domain,            "YOUR_DOMAIN"
set :repository,        "ssh://#{domain}/~/#{application}.git"
set :use_sudo,          false
set :user,              "victorstan"  # The server's user for deploys
set :scm,               :git
set :scm_username,      "passenger"
set :scm_passphrase,    "YOUR_PASSWORD"  # The deploy user's password
set :deploy_to,         "/srv/www/#{application}"
set :keep_releases,     3
set :branch,            "master"
set :deploy_via,        :copy # won't make cap prompt for password when deploying
set :scm_verbose,       true
# set :ssh_options,     {:forward_agent => true} # ?

set :rvm_ruby_string,   'ruby-2.0.0-p247'
set :rvm_type,          :user
set :rvm_install_type,  :stable

set :bundle_dir,        ''

set :default_shell,     :bash

# set :whenever_command,  "bundle exec whenever"
# set :whenever_environment, defer { production } # default to production

default_run_options[:pty] = true

before 'deploy', 'rvm:install_ruby'
before 'deploy:setup', 'rvm:install_ruby'

require "bundler/capistrano"
require "rvm/capistrano"
# require "whenever/capistrano"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

namespace :utils do
  desc "Enable Apache2 site"
  task :enable, :roles => :app do
    sudo "a2ensite #{application}"
    sudo "service apache2 graceful"
  end

  desc "Restart Apache2 Service: sudo service apache2 graceful"
  task :restartA2, :role => :app do
    sudo "service apache2 graceful"
  end
end

namespace :bundler do
  desc "Run: bundle install"
  task :install_gems, :role => :app do
    run "#{current_release} bundle install"
  end

  desc "Run: bundle update"
  task :update_gems, :role => :app do
    run "#{current_release} bundle update"
  end

  desc "Install Bundler"
  task :install_bundler, :role => :app do
    run "gem install bundler"
  end
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start, :roles => :app do
    sudo "chown -R www-data:www-data #{current_release}/public"
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  # desc "Restart Application"
  # task :restart, :roles => :app, :except => { :no_release => true } do
  #   run "cd #{release_path} && touch tmp/restart.txt"
  # end

  desc "Migrate DB"
  task :migrate_db do
    run "cd #{current_path} && bundle exec rake db:migrate RAILS_ENV=production"
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :cold do       # Overriding the default deploy:cold
    update
    load_schema       # My own step, replacing migrations.
    start
  end

  task :load_schema, :roles => :app do
    run "cd #{current_release}; bundle exec rake db:schema:load RAILS_ENV=production"
  end
end

namespace :run_rake do
  desc "rake: `cap run_rake:run task=`"
  # run like: cap staging rake:invoke task=a_certain_task
  task :run, :roles => :app do
    run "cd #{current_release}; bundle exec rake #{ENV['task']} RAILS_ENV=production"
  end
end

namespace :cache do
  desc "Clear memcache after deployment"
  task :clear, :roles => :app do
    run "cd #{current_release} && bundle exec rake cache:clear RAILS_ENV=production"
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

# after "deploy", "rvm:trust_rvmrc"

# namespace :assets do
#   desc "Clean assets with rake"
#   task :clean, :current_release => :app do
#     run "cd #{release_path}; bundle exec rake assets:clean RAILS_ENV=production"
#   end
# end

# after "deploy:restart", "deploy:cleanup"

# after 'deploy:update_code' do
#   run "cd #{current_release}; bundle exec rake assets:precompile RAILS_ENV=production"
# end

# after 'deploy:restart' do
#   run "cd #{deploy_to}/current; bundle exec rake assets:clean RAILS_ENV=production"
# end
