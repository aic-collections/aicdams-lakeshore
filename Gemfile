source 'https://rubygems.org'

gem 'rails', '4.2.4'

# Hydra Gems
gem 'sufia', github: 'projecthydra/sufia', ref: '08a677d7c5916e530890bc9d3ebe425e5cb6c943'
gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'
gem 'active-fedora', '= 9.4.2'
gem 'hydra-head', github: 'projecthydra/hydra-head', ref: '84b4406c0f369dc2562e06a981b7ea925ceab814'

gem 'blacklight_range_limit'
gem 'coffee-rails', '~> 4.1.0'
gem 'devise'
gem 'devise-guests', '~> 0.3'
gem 'hydra-role-management'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'resque-pool'
gem 'rsolr', '~> 1.0.6'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'jettywrapper'
  gem 'sqlite3'
end

group :development do
  gem 'capistrano-rails', require: false
end

group :test do
  gem 'capybara', '~> 2.0'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.0'
end

group :production do
  gem 'pg'
  gem 'passenger'
end
