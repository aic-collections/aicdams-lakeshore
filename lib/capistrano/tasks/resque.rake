namespace :resque do

  desc "Start resque pool workers"
  task :start do
    on roles(:app) do
      execute "cd #{fetch(:current_release)} && bundle exec resque-pool --daemon --environment #{fetch(:rails_env)} --pidfile #{fetch(:resque_pid_file)} start"
    end
  end

  desc "Stop resque pool workers"
  task :stop do
    on roles(:app) do
      execute "kill -2 `cat #{fetch(:resque_pid_file)}`"
    end
  end

  desc "Restart resque"
  task :restart do
    invoke "resque:stop"
    sleep(5)
    invoke "resque:start"
  end

end
