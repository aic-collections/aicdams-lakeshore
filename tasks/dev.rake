SolrWrapper.default_instance_options = {
  port: '8984',
  instance_dir: 'tmp/solr',
  download_dir: 'tmp',
  version: "5.5.0"
}

require 'rspec/core'
require 'rspec/core/rake_task'
require 'active_fedora/cleaner'
require 'jettywrapper'
require 'solr_wrapper'
require './spec/support/fixture_loader'
require './spec/support/list_loader'
require 'rubocop/rake_task' unless Rails.env.production?

class DevelopmentLoader
  include FixtureLoader
  include ListLoader
end

Jettywrapper.hydra_jetty_version = "v8.5.0"

def solr_config
  File.join(Rails.root, 'solr', 'config')
end

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc 'Run spec tests'
task :spec do
  RSpec::Core::RakeTask.new(:spec)
end

desc "Run continuous integration test"
task ci: [:rubocop, 'aic:jetty:prep', 'db:migrate'] do
  jetty_params = Jettywrapper.load_config

  SolrWrapper.wrap do |solr|
    solr.with_collection(name: 'aic_test', dir: solr_config) do
      error = Jettywrapper.wrap(jetty_params) do
        Rake::Task['spec'].invoke
      end
    end
  end
end

desc "Clean out development environment"
task clean: ['jetty:empty', 'db:drop', 'db:migrate']

namespace :jetty do

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

  desc "Create fixture resources in Fedora from turtle files"
  task load_fixtures: :environment do
    ActiveFedora::Cleaner.clean!
    loader = DevelopmentLoader.new
    Dir.glob("spec/fixtures/*.ttl").each do |f|
      loader.load_fedora_fixture(f, true)
    end
    loader.load_lists
  end

  desc "Load lists into Fedora"
  task load_lists: :environment do
    DevelopmentLoader.new.load_lists
  end

  desc "Create test users for AIC testing specifically, dependent on local Shibboleth settings"
  task create_users: :environment do
    AICUser.create(nick: "laketest", pref_label: "Laketest User", given_name: "Laketest", family_name: "User")
    Department.create(citi_uid: "87", pref_label: "Laketest department")
  end
end

namespace :solr do

  desc 'Starts a configured solr instance for local development and testing'
  task start: :environment do
    solr = SolrWrapper.default_instance
    solr.extract_and_configure
    solr.start
    solr.create(name: 'aic_development', dir: solr_config)
    solr.create(name: 'aic_test', dir: solr_config)
  end

end

namespace :aic do

  namespace :jetty do
    desc "Clean and prepare jetty"
    task prep: ['jetty:clean'] do
      `cp jetty_config/jetty.xml jetty/etc/`
      `cp jetty_config/keystore jetty/etc/`
    end
  end

end
