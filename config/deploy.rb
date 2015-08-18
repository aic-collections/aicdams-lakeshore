# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'lakeshore'
set :repo_url, 'https://github.com/aic-collections/aicdams-lakeshore.git'
set :base_dir, "/usr/local/hydra"
set :aic_config_dir, "#{fetch(:base_dir)}/config"
set :user, 'awead'
set :deploy_to, "#{fetch(:base_dir)}/#{fetch(:application)}"
set :use_sudo, false
set :ssh_options, { keys: [File.join(ENV["HOME"], ".ssh", "id_rsa")] }
set :aic_proxy, "sysprox.artic.edu:3128"

set :default_env, { 
  path: "$PATH:#{fetch(:base_dir)}/bin",
  http_proxy: "#{fetch(:aic_proxy)}"
}

set :current_release, "#{fetch(:deploy_to)}/current"

# Solr
# We'll deploy solr to the same server using a git repo
set :solr_application, 'solr-jetty'
set :solr_application_dir, "#{fetch(:base_dir)}/#{fetch(:solr_application)}"
set :solr_repo_url, "https://github.com/awead/#{fetch(:solr_application)}.git"

# Resque
set :resque_pid_file, "#{fetch(:current_release)}/tmp/pids/resque-pool.pid"

set :rails_env, 'production'
set :log_level, :debug
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "master"

set :linked_files, fetch(:linked_files, []).push(
  'config/admin.yml',
  'config/blacklight.yml',
  'config/database.yml',
  'config/fedora.yml',
  'config/redis.yml',
  'config/secrets.yml',
  'config/solr.yml',
)
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
)
set :keep_releases, 10

namespace :deploy do

  # Create a symlink in the shared directory to the config directory
  # This keeps the configuration files separate from Capistratno's managed deploy directory.
  before 'check:linked_dirs', :link_config do
    on roles(:web) do
      execute "cd #{fetch(:deploy_to)}/shared; ln -sf #{fetch(:aic_config_dir)}"
    end
  end

  after :finished, :post_install_tasks do
    on roles(:web) do
      execute "cd #{fetch(:deploy_to)}/current && /usr/bin/env rake rails:update:bin RAILS_ENV=#{fetch(:rails_env)}"
      execute "cd #{fetch(:deploy_to)}/current && /usr/bin/env rake solr:reindex RAILS_ENV=#{fetch(:rails_env)}"
    end
  end

end
