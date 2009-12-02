# encoding: utf-8

require_relative "../spec_helper"

require "rango/controller"
require "rack/mock"

describe Rango::Controller do
  before(:each) do
    env = Rack::MockRequest.env_for("/")
    @controller = Rango::Controller.new(env)
  end

  it "should respond to request" do
    @controller.should respond_to(:request)
  end

  it "should respond to params" do
    @controller.should respond_to(:params)
  end

  it "should have logger" do
    @controller.should respond_to(:logger)
    #@controller.logger.should eql(Project.logger)
  end
end
