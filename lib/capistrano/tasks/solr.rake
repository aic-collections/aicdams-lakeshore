namespace :solr do

  desc "Install solr repo"
  task :install do
    on roles(:app) do
      execute "git clone #{fetch(:solr_repo_url)} #{fetch(:solr_application_dir)}"
    end
  end

  desc "Update solr repo"
  task :update do
    on roles(:app) do
      execute "cd #{fetch(:solr_application_dir)}; git pull"
    end
  end

  desc "Re-install solr repo -- WARNING: Deletes everything in Solr!"
  task :reinstall do
    on roles(:app) do
      execute "rm -Rf #{fetch(:solr_application_dir)}"
      invoke "solr:install"
      invoke "solr:config"
    end
  end

  desc "Copies solr configuration from current release"
  task :config do
    on roles(:app) do
      execute "cp -Rf #{fetch(:deploy_to)}/current/solr_conf/solr.xml #{fetch(:solr_application_dir)}/solr"
      execute "mkdir -p #{fetch(:solr_application_dir)}/solr/aic-production/conf"
      execute "cp -Rf #{fetch(:deploy_to)}/current/solr_conf/conf/* #{fetch(:solr_application_dir)}/solr/aic-production/conf"
    end
  end

  desc "Stop jetty"
  task :stop do
    on roles(:app) do
      execute "killall java"
    end
  end

  desc "Start jetty"
  task :start do
    on roles(:app) do
      execute "cd #{fetch(:solr_application_dir)}; nohup java -jar start.jar > /dev/null &"
    end
  end

  desc "Restart jetty"
  task :restart do
    on roles(:app) do
      invoke "solr:stop"
      sleep(5)
      invoke "solr:start"
    end
  end

end
