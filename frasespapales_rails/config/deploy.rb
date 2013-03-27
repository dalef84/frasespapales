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

after 'deploy:setup', 'copy_secret_files'
after 'deploy:setup', 'precompile'
after 'deploy:setup', 'restart_server'

task :copy_secret_files, :role => :web do
    # whatever you need to do
    run "cp -f database.yml #{release_path}/config/database.yml"
    run "cp -f aws.yml #{release_path}/config/aws.yml"
    run "cp -f s3.yml #{release_path}/config/s3.yml"
    
end

task :precompile, :role => :web do
    run "cd #{release_path}/ && rake assets:precompile"
end

task :restart_server, :role => :web do
    run "rvmsudo apachectl restart"
end



#############################################################
#	Git
#############################################################

set :repository, "git@github.com:dalef84/frasespapales.git"  # Your clone URL
set :scm, :git
set :branch, "master"
#set :deploy_via, :remote_cache

