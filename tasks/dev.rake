require 'rspec/core'
require 'rspec/core/rake_task'
require 'active_fedora/cleaner'
require 'jettywrapper'
require './spec/support/fixture_loader'
require './spec/support/list_loader'
require 'rubocop/rake_task' unless Rails.env.production?

class DevelopmentLoader
  include FixtureLoader
  include ListLoader
end

Jettywrapper.hydra_jetty_version = "v8.5.0"

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc "Run continuous integration test"
task ci: [:rubocop, 'aic:jetty:prep', 'db:migrate'] do
  jetty_params = Jettywrapper.load_config

  SolrWrapper.wrap({ config: '.solr_wrapper' }) do |solr|
    solr.with_collection(name: 'aic_test', dir: File.join(Rails.root, 'solr', 'config')) do
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
  end

  desc "Load lists into Fedora"
  task load_lists: :environment do
    DevelopmentLoader.new.load_lists
  end

  desc "Create test users for AIC testing specifically, dependent on local Shibboleth settings"
  task create_users: :environment do
    AICUser.create(nick: "laketest", pref_label: "US-1484", given_name: "lake", family_name: "test")
    AICUser.create(nick: "scossu", pref_label: "US-1117", given_name: "Stefano", family_name: "Cossu")
    AICUser.create(nick: "scossuadmin", pref_label: "US-758", given_name: "[admin] Stefano", family_name: "Cossu")
    AICUser.create(nick: "awead", pref_label: "US-583", given_name: "Adam", family_name: "Wead")
    AICUser.create(nick: "aweadadmin", pref_label: "US--32351", given_name: "[admin] Adam", family_name: "Wead")
    AICUser.create(nick: "tshah", pref_label: "US-1305", given_name: "Tina", family_name: "Shah")
    Department.create(citi_uid: "87", pref_label: "Visitor Services")
    Department.create(citi_uid: "112", pref_label: "Information Services")
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
