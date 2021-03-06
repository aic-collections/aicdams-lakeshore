require 'active_fedora/cleaner'
require 'factory_girl_rails'

namespace :dev do
  desc "Clean out all resources"
  task clean: :environment do
    ActiveFedora::Cleaner.clean!
    cleanout_redis
    clear_directories
  end

  desc "Prep dev environment"
  task prep: ['db:reset', :clean, 'lakeshore:load_lists', 'fedora:create_users', 'fedora:create_citi_resources']
end

namespace :fedora do
  desc "Register namespace prefixes in Fedora"
  task :config do
    puts "Registering namespace prefixes in Fedora"
    system("script/fedora_config.sh")
  end

  desc "Create test users for AIC testing specifically, dependent on local Shibboleth settings"
  task create_users: :environment do
    create_aic_user(nick: "laketest", pref_label: "US-1484", given_name: "lake", family_name: "test")
    create_aic_user(nick: "inactivetest", pref_label: "US-2434", given_name: "inactive", family_name: "test")
    create_aic_user(nick: "scossu", pref_label: "US-1117", given_name: "Stefano", family_name: "Cossu")
    create_aic_user(nick: "scossuadmin", pref_label: "US-758", given_name: "[admin] Stefano", family_name: "Cossu")
    create_aic_user(nick: "awead", pref_label: "US-583", given_name: "Adam", family_name: "Wead")
    create_aic_user(nick: "aweadadmin", pref_label: "US--32351", given_name: "[admin] Adam", family_name: "Wead")
    create_aic_user(nick: "tshah", pref_label: "US-1305", given_name: "Tina", family_name: "Shah")
    create_aic_user(nick: "rdoll", pref_label: "US-1211", given_name: "Becca", family_name: "Doll")
    Department.create(citi_uid: "87", pref_label: "Visitor Services")
    Department.create(citi_uid: "112", pref_label: "Information Services")
    Department.create(citi_uid: "6", pref_label: "European Decorative Arts")
    User.create(email: "citi", password: "password") unless User.find_by_user_key("citi")
    User.create(email: "combine", password: "password") unless User.find_by_user_key("combine")
    User.create(email: "geneva", password: "password") unless User.find_by_user_key("geneva")
  end

  desc "Create sample CITI resources"
  task create_citi_resources: :environment do
    FactoryGirl.create(:agent, :with_sample_metadata)
    FactoryGirl.create(:exhibition, :with_sample_metadata)
    FactoryGirl.create(:work, :with_sample_metadata)
    FactoryGirl.create(:place, :with_sample_metadata)
    FactoryGirl.create(:shipment, :with_sample_metadata)
    FactoryGirl.create(:transaction, :with_sample_metadata)
    add_artists_and_current_locations_to_work()
  end

  def create_aic_user(args)
    AICUser.new(args).tap do |u|
      unless u.nick == "inactivetest"
        u.type << AIC.ActiveUser
      end
    end.save
  end

  def add_artists_and_current_locations_to_work()
    work = Work.last
    work.artist_uris = [Agent.first.uri]
    work.current_location_uris = [Place.first.uri]
    work.save!
  end

  def cleanout_redis
    Redis.current.keys.map { |key| Redis.current.del(key) }
  rescue => e
    Logger.new(STDOUT).warn "WARNING -- Redis might be down: #{e}"
  end

  def clear_directories
    FileUtils.rm_rf(Sufia.config.derivatives_path)
    FileUtils.mkdir_p(Sufia.config.derivatives_path)
    FileUtils.rm_rf(Sufia.config.upload_path.call)
    FileUtils.mkdir_p(Sufia.config.upload_path.call)
  end
end
