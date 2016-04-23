require 'faraday'
require 'openssl'

# Ouch. Only if we have self-signed certs.
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
cert = File.join(Rails.root, "config/fedora-cert.pem")
Faraday.default_connection_options.ssl.ca_file = cert if File.exist?(cert)
