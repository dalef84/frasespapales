# This is a sample Capistrano config file for EC2 on Rails.
# It should be edited and customized.

require "rvm/capistrano"                  # Load RVM's capistrano plugin.

set :application, "frasespapales"

# The directory on the EC2 node that will be deployed to
set :deploy_to, "/var/www/#{application}"
actual_release_path = "#{release_path}/frasespapales_rails"

# Your EC2 instances. Use the ec2-xxx....amazonaws.com hostname, not
# any other name (in case you have your own DNS alias) or it won't
# be able to resolve to the internal IP address.
role :web,      "ec2-54-232-196-174.sa-east-1.compute.amazonaws.com"
role :memcache, "ec2-54-232-196-174.sa-east-1.compute.amazonaws.com"
role :db,       "ec2-54-232-196-174.sa-east-1.compute.amazonaws.com", :primary => true

default_run_options[:pty] = true

set :user, "admin"
set :admin_runner, "admin"
set :ssh_options, {:user => "admin" }
set :ssh_options, {:auth_methods => "publickey"}
set :ssh_options, {:keys => ["/Users/damianferrai/.ssh/da", "/Users/damianferrai/.ssh/ec2admin"]}
set :ssh_options, {:forward_agent => true }
set :ssh_options, {:verbose => :debug}

# Whatever you set here will be taken set as the default RAILS_ENV value
# on the server. Your app and your hourly/daily/weekly/monthly scripts
# will run with RAILS_ENV set to this value.
set :rails_env, "production"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_install_ruby_params, '1.9.3 --with-gcc=clang'      # for jruby/rbx default to 1.9 mode


#before 'deploy:setup', 'rvm:create_gemset' # only create gemset
#before 'deploy:setup', 'rvm:import_gemset' # import gemset from file

namespace :deploy do
    task :build_gems, :role => :web do
        logger.info "Building gems"
        run "cd #{actual_release_path} && rvmsudo bundle install"
    end
    
    task :copy_secret_files, :role => :web do
        logger.info "Copying secret files"
        top.upload(File.expand_path("../database.yml", __FILE__), "#{actual_release_path}/config/database.yml")
        top.upload(File.expand_path("../aws.yml", __FILE__), "#{actual_release_path}/config/aws.yml")
        top.upload(File.expand_path("../s3.yml", __FILE__), "#{actual_release_path}/config/s3.yml")
    end
    
    task :precompile, :role => :web do
        logger.info "Precompiling for deployment"
        run "cd #{actual_release_path}/ && rake assets:precompile"
    end
    
    task :restart_server do
        logger.info "Finished. Restarting apache"
        run "touch #{current_path}/tmp/restart.txt"
    end
end

after 'deploy:finalize_update', 'deploy:build_gems'
after 'deploy:finalize_update', 'deploy:copy_secret_files'
after 'deploy:finalize_update', 'deploy:precompile'
# TODO: after 'deploy:finalize_update', 'deploy:restart_server'



#############################################################
#	Git
#############################################################

set :repository, "git@github.com:dalef84/frasespapales.git"  # Your clone URL
set :scm, :git
set :branch, "master"
#set :deploy_via, :remote_cache

