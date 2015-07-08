namespace :passenger do
  
  desc "Install Passenger Apache module"
  task :install do
    on roles(:app) do
      execute "passenger-install-apache2-module --auto"
    end
  end

  desc "Creates/updates Passenger and vhost configs for Apache"
  task :config do
    on roles(:app) do
      execute("echo \"# This file is created by Capistrano. Refer to passenger:config\" > #{fetch(:base_dir)}/.passenger.tmp")
      execute("echo \"PassengerFriendlyErrorPages On\" >>  #{fetch(:base_dir)}/.passenger.tmp") unless fetch(:stage).to_s.downcase.match(/production/)
      execute "passenger-install-apache2-module --snippet >>  #{fetch(:base_dir)}/.passenger.tmp"
      execute "/bin/mv -f #{fetch(:base_dir)}/.passenger.tmp /etc/httpd/conf.d/passenger.conf"
      execute "/bin/cp -f #{fetch(:aic_config_dir)}/lakeshore-vhost.conf /etc/httpd/conf.d/lakeshore-vhost.conf" 
    end
  end

end
