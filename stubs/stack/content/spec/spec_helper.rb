# encoding: utf-8

# NOTE: we don't have to require spec, webrat,
# rack/test or whatever, it's bundler job to do it

# load test environment include dependencies
RACK_ENV = "test"
require_relative "../init.rb"

require "spec"
require "webrat"
require "rack/test"

# load config.ru
require "rango/utils"
Rango::Utils.load_rackup

# webrat
Webrat.configure do |config|
  config.mode = :rack
end

# rspec
Spec::Runner.configure do |config|
  config.include Rack::Test::Methods
  config.include Webrat::Matchers

  # automigrate database
  # TODO: with this setup it runs after custom block, so
  # if you create a record, it will be destroyed immediately
  #config.before(:each) do
  #  DataMapper.auto_migrate!
  #end

  # for rack-test
  def app
    Rango::Router.app
  end
end
