namespace :repo do

  desc "Setup a complete development repo on a server"
  task :clone do
    on roles(:app) do
      execute "cd #{fetch(:base_dir)} && git clone #{fetch(:repo_url)}"
    end
  end

  desc "Configure repo using yml files stored on server"
  task :config do
    on roles(:app) do
      execute "cp #{fetch(:aic_config_dir)}/*.yml #{fetch(:base_dir)}/aicdams-lakeshore/config/"
      execute "cd #{fetch(:base_dir)}/aicdams-lakeshore && HTTP_PROXY=#{fetch(:aic_proxy)} bundle install"
      execute "cd #{fetch(:base_dir)}/aicdams-lakeshore && /usr/bin/env rake db:migrate"
      execute "cd #{fetch(:base_dir)}/aicdams-lakeshore && /usr/bin/env rake rails:update:bin"
    end
  end

end
