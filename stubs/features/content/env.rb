# encoding: utf-8

require "spec"
#require "merb_cucumber/world/simple"
require "rango/support/cucumber/world/webrat"
require "rango/support/cucumber/helpers/datamapper"

# Uncomment if you want transactional fixtures
# Rango::Test::World::Base.use_transactional_fixtures

# Quick fix for post features running Rspec error, see
# http://gist.github.com/37930
def Spec.run? ; true; end

# Load shared stuff
# It is not required for running all features,
# but it is required for running just one feature
# Example: bin/cucumber features/static/static.feature
Dir["features/shared/*.rb"].each do |file|
  require file
end

# Start each step with clean DB and created default admin user
#World do |world|
#  DataMapper.auto_migrate!
#  User.generate(:admin)
#  world # must be returned
#end

# AfterStep
# or transactional?
Before do
  DataMapper.auto_migrate!
end

Rango.boot
