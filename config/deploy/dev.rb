# frozen_string_literal: true
# Deploy using Rails development environment to enable local development on the server directly
set :rails_env, 'development'
server 'aicdamsdev01.artic.edu', user: 'awead', roles: %w(web app db)

# An inelegant hack: delete the precompiled assets because we're in development mode and don't need them
namespace :deploy do
  after :finished, :delete_assets do
    on roles(:web) do
      execute "rm -Rf #{fetch(:deploy_to)}/current/public/assets/*"
    end
  end
end
