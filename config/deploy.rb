# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'lakeshore'
set :repo_url, 'https://github.com/aic-collections/aicdams-lakeshore.git'

set :user, 'awead'
set :deploy_to, "/usr/local/hydra/#{fetch(:application)}"
set :use_sudo, false
set :ssh_options, { keys: [File.join(ENV["HOME"], ".ssh", "id_rsa")] }
set :default_env, { path: "$PATH:/usr/local/hydra/bin" }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
