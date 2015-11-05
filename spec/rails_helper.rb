ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/active_model/mocks'
require 'active_fedora/cleaner'
require 'database_cleaner'
require 'factory_girl'
require 'devise'

# Require support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.before :suite do
    ActiveFedora::Cleaner.clean!
    class TestLoader
      include FixtureLoader
      include ListLoader
    end
    loader = TestLoader.new
    Dir.glob("spec/fixtures/*.ttl").each do |f|
      loader.load_fedora_fixture(f)
    end
    loader.load_lists
  end

  config.before :each do |example|
    unless example.metadata[:no_clean]
      # Clear out Redis
      begin
        $redis.keys('events:*').each { |key| $redis.del key }
        $redis.keys('User:*').each { |key| $redis.del key }
        $redis.keys('GenericFile:*').each { |key| $redis.del key }
      rescue => e
        Logger.new(STDOUT).warn "WARNING -- Redis might be down: #{e}"
      end 
    end
  end

  config.before :each do |example|
    if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end  

  config.after do
    DatabaseCleaner.clean
  end

  config.include Devise::TestHelpers, type: :controller
  config.include Capybara::RSpecMatchers, type: :input
  config.include InputSupport, type: :input
  config.include FactoryGirl::Syntax::Methods
  config.include SessionSupport, type: :feature
  config.include FixtureLoader

  config.include Warden::Test::Helpers, type: :feature
  config.after(:each, type: :feature) { Warden.test_reset! }
end

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'

    factory :jill do
      email 'jilluser@example.com'
    end
  end
end

module FactoryGirl
  def self.find_or_create(handle, by=:email)
    tmpl = FactoryGirl.build(handle)
    tmpl.class.send("find_by_#{by}".to_sym, tmpl.send(by)) || FactoryGirl.create(handle)
  end
end
