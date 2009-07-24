# encoding: utf-8

# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails_session',
  :secret      => 'a6f484fbd2e275a36162f12bbb6f6981fbf33cd0b8b3a9243b335979731b2d2c81ddbf6649a21fb2158e3504688b9172fe1fe1a9b7dcf962fd27d7c96453cc40'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
