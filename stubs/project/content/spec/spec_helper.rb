require_relative "../init"

require "spec"
require "webrat"
require "rack/test"
require "rango/testing"

Rango::Testing.load_rackup

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods

  def app
    Project.router
  end
end
