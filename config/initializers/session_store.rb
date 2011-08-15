# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_spice_counsel_session',
  :secret      => '88ff5b0f7ea0548ac478ae3a109bbfae86da47fec09bfe50f274efff69114b85558187bfe688bbc5acde9b62a26792e31bce0ebfda769a3b8ff08f57273a4130'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
