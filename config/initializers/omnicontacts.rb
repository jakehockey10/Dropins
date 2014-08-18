require 'omnicontacts'

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], { redirect_path: '/oauth2callback', ssl_ca_file: '/usr/lib/ssl/certs/ca-certificates.crt', max_results: 1000}
  # importer :yahoo, "consumer_id", "consumer_secret", {:callback_path => '/callback'}
  # importer :hotmail, "client_id", "client_secret"
  # importer :facebook, "client_id", "client_secret"
end