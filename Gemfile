source 'https://rubygems.org'

gem 'rails', '4.2.1'

# Hydra Gems
gem 'sufia', '~> 6.2'
gem 'active-fedora', github: 'projecthydra/active_fedora', ref: 'd11806b4f7e3aa69c2241a6d2b1a485fe00a6880'
gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'

gem 'coffee-rails', '~> 4.1.0'
gem 'devise'
gem 'devise-guests', '~> 0.3'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'linkeddata', '=1.1.11'
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
  gem 'rspec-rails', '~> 3.0'
end

group :production do
  gem 'pg'
  gem 'passenger'
end
