require 'active_fedora/cleaner'

desc "Run continuous integration test"
task ci: ['jetty:clean', 'db:migrate'] do
  jetty_params = Jettywrapper.load_config
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end

desc "Clean out development environment"
task clean: ['jetty:empty', 'db:drop', 'db:migrate']

namespace :jetty do

  desc "Configure Jetty"
  task config: ['jetty:clean', 'sufia:jetty:download_jars'] #, 'jetty:start', 'fedora:config']

  desc "Empty out jetty of all its records"
  task empty: :environment do
    raise "You can't do this in production" if Rails.env.match("production")
    ActiveFedora::Cleaner.clean!
  end

end

namespace :fedora do
  desc "Register namespace prefixes in Fedora"
  task :config do
    puts "Registering namespace prefixes in Fedora"
    system("script/fedora_config.sh")
  end
end

namespace :aic do

  namespace :jetty do

    desc "Clean and prepare jetty"
    task prep: ['jetty:clean', 'sufia:jetty:download_jars']

    desc "Configure solr"
    task :solr_config do
      `cp solr_conf/solr.xml jetty/solr/solr.xml`
      `rm -Rf jetty/solr/*-core`
      `rm -Rf jetty/solr/aic-*`
      `mkdir jetty/solr/aic-development`
      `mkdir jetty/solr/aic-test`
      `mkdir jetty/solr/aic-production`
      `cp -R solr_conf/conf jetty/solr/aic-development`
      `cp -R solr_conf/conf jetty/solr/aic-test`
      `cp -R solr_conf/conf jetty/solr/aic-production`
    end

  end

end
