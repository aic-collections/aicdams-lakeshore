ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/active_model/mocks'
require 'active_fedora/cleaner'
require 'database_cleaner'
require 'factory_girl'
require 'devise'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.before do
    ActiveFedora::Cleaner.clean!
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.include Devise::TestHelpers, type: :controller
  config.include Capybara::RSpecMatchers, type: :input
  config.include FactoryGirl::Syntax::Methods
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
