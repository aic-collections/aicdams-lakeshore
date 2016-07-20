# frozen_string_literal: true
# AIC Lakeshore test server
set :user, 'rbrun'
server 'aicdamstest02.artic.edu', user: 'rbrun', roles: %w(web app db)

set :linked_files, fetch(:linked_files, []).push('config/fedora-cert.pem')
