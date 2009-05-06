# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_new_mano_session',
  :secret      => '87e8cd8add7a0905b38b325c84aec8a78d85e804ee69a5ec8ea4903b6e5bdf76e5327380abab9ae4e2575f2d748b5f64edd71a91f61df19915912d2c5291064a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
