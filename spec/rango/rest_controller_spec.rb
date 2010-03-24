# encoding: utf-8

require_relative "../spec_helper"

require "rack/mock"
require "rango/rest_controller"

class TestRestController < Rango::RESTController
end

describe Rango::RESTController do
  before(:each) do
    env = Rack::MockRequest.env_for("/")
    @controller = TestRestController.new(env)
  end
end
