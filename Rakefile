# frozen_string_literal: true
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

load File.expand_path('../tasks/dev.rake', __FILE__) unless Rails.env.production?

Rake::Task[:default].prerequisites.clear
task default: :ci
