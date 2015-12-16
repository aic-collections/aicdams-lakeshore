require 'faraday'
cert = File.join(Rails.root, "config/fedora-cert.pem")
Faraday.default_connection_options.ssl.ca_file = cert if File.exist?(cert)
