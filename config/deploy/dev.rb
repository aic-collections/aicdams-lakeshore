# frozen_string_literal: true
# AIC Lakeshore development server
set :user, 'rbrun'
server 'aicdamsdev01.artic.edu', user: 'rbrun', roles: %w(web app db)
