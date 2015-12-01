namespace :resque do

  desc "Start resque pool workers"
  task :start do
    on roles(:app) do
      execute "cd #{fetch(:current_release)} && bundle exec resque-pool --daemon --environment #{fetch(:rails_env)} start"
    end
  end

  desc "Stop resque pool workers"
  task :stop do
    on roles(:app) do
      execute "ps -ax | grep resque | awk '{ print $1 }' | xargs kill -9"
    end
  end

  desc "Restart resque"
  task :restart do
    invoke "resque:stop"
    sleep(5)
    invoke "resque:start"
  end

end
