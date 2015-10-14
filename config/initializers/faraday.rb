require 'faraday'
cert = File.join(Rails.root, "config/fedora-cert.pem")
if File.exists?(cert)
  Faraday.default_connection_options.ssl.ca_file = cert
end
