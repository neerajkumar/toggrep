# RVM bootstrap
require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'capistrano-resque'

load 'config/recipes/base'
load 'config/recipes/nginx'
load 'config/recipes/unicorn'
load 'config/recipes/mysql'
load 'config/recipes/check'

set :application, 'toggrep'

set :user do
  default_user = 'deploy'
  user = Capistrano::CLI.ui.ask('username (Default is deploy) : ')
  user = default_user if user.empty?
  user
end

set :stages, %w(staging production)
set :default_stage, 'staging'

set :rvm_type, :user

set :deploy_to, "/home/#{user}/#{application}" # Directory in which the deployment will take place
set :deploy_via, :remote_cache
set :use_sudo, false

set :ssl_enabled, false
# set :cert_path, "#{current_path}/ssl-certs/SSL.crt"
# set :cert_key_path, "#{current_path}/ssl-certs/ssl.key"

# Source Code Details
set :scm, "git"
set :repository, "git@git.assembla.com:papayaheaderlabs.elderberry.git"

set :branch do
  default_branch = 'master'
  branch = Capistrano::CLI.ui.ask('Branch to deploy (Default:- Master) : ')
  branch = default_branch if branch.empty?
  branch
end

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

# # set :whenever_command, "bundle exec whenever"
# # require "whenever/capistrano"
# server '178.62.155.118', :web, :app, :db, primary: true
# set :application, 'toggrep'
# set :user, 'deployer'
# set :deploy_to, "/home/#{user}/www/apps/#{application}"
# set :rails_env, 'production'
# set :deploy_via, :remote_cache
# set :use_sudo, false
# # set :port, 60321
# set :scm, :git
# set :repository, 'git@github.com:tataronrails/toggrep.git'
# set :branch, 'master'
# set :domain, "#{user}@178.62.155.118"
# set :shared_children, shared_children + %w{public/uploads}
# default_run_options[:pty] = true
# ssh_options[:forward_agent] = true
#
# set :default_environment, {
#     'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
# }
#
# namespace :deploy do
#
#   %w[start stop restart].each do |command|
#     desc "#{command} unicorn server"
#     task command, roles: :app, except: {no_release: true} do
#       run "/etc/init.d/unicorn_#{application} #{command}"
#     end
#   end
#
#   task :setup_config, roles: :app do
#     sudo "ln -nfs #{current_path}/config/production/nginx.conf /etc/nginx/sites-enabled/#{application}.conf"
#     sudo "ln -nfs #{current_path}/config/production/unicorn_init.sh /etc/init.d/unicorn_#{application}"
#   end
#   after "deploy:setup", "deploy:setup_config"
#
#   task :symlink_config, roles: :app do
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#     run "ln -nfs #{shared_path}/config/email.yml #{release_path}/config/email.yml"
#   end
#   after 'deploy:finalize_update', 'deploy:symlink_config'
#
#   desc 'Make sure local git is in sync with remote.'
#   task :check_revision, roles: :web do
#     unless `git rev-parse HEAD` == `git rev-parse origin/master`
#       puts 'WARNING: HEAD is not the same as origin/master'
#       puts "Run `git push` to sync changes."
#       exit
#     end
#   end
#
#   before 'deploy', 'deploy:check_revision'
#
# end
#
# after 'deploy', 'deploy:cleanup' # keep only the last 5 releases
