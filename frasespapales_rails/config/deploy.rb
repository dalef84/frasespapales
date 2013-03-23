# This is a sample Capistrano config file for EC2 on Rails.
# It should be edited and customized.

require "rvm/capistrano"                  # Load RVM's capistrano plugin.

set :application, "frasespapales"

# The directory on the EC2 node that will be deployed to
set :deploy_to, "/var/www/#{application}"

# Your EC2 instances. Use the ec2-xxx....amazonaws.com hostname, not
# any other name (in case you have your own DNS alias) or it won't
# be able to resolve to the internal IP address.
role :web,      "ec2-54-232-196-174.sa-east-1.compute.amazonaws.com"
role :memcache, "ec2-54-232-196-174.sa-east-1.compute.amazonaws.com"
role :db,       "ec2-54-232-196-174.sa-east-1.compute.amazonaws.com", :primary => true

default_run_options[:pty] = true


set :user, "ec2-user"
#set :use_sudo, false
set :admin_runner, "admin"

set :ssh_options, {:user => "ec2-user" }

set :ssh_options, {:auth_methods => "publickey"}
set :ssh_options, {:keys => ["/Users/damianferrai/.ssh/da"]}
set :ssh_options, {:forward_agent => true }
set :ssh_options, {:verbose => :debug}

# NOTE: for some reason Capistrano requires you to have both the public and
# the private key in the same folder, the public key should have the 
# extension ".pub".
#ssh_options[:keys] = ["/Users/damianferrai/.ssh/id_rsa"]


#############################################################
#	Git SCM
#############################################################

set :repository, "git@github.com:dalef84/frasespapales.git"  # Your clone URL
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache

# Whatever you set here will be taken set as the default RAILS_ENV value
# on the server. Your app and your hourly/daily/weekly/monthly scripts
# will run with RAILS_ENV set to this value.
set :rails_env, "production"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_install_ruby_params, '1.9.3 --with-gcc=clang'      # for jruby/rbx default to 1.9 mode
#set :rvm_install_pkgs, %w[iconv libyaml openssl] # package list from https://rvm.io/packages
set :rvm_install_pkgs, %w[] # package list from https://rvm.io/packages


#before 'deploy:setup', 'rvm:install_rvm'   # install RVM
#before 'deploy:setup', 'rvm:install_pkgs'  # install RVM packages before Ruby
#before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:
before 'deploy:setup', 'rvm:create_gemset' # only create gemset
before 'deploy:setup', 'rvm:import_gemset' # import gemset from file


#############################################################
#	Passenger
#############################################################

namespace :passenger do
    desc "Restart Application"
    task :restart do
        run "touch #{current_path}/tmp/restart.txt"
    end
end

after :deploy, "passenger:restart"