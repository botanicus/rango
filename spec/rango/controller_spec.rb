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

  describe "#params" do
    before(:each) do
      env = Rack::MockRequest.env_for("/?ssl=true")
      @controller = Rango::Controller.new(env)
    end

    it "should have indifferent access" do
      @controller.params[:ssl].should  eql("true")
      @controller.params["ssl"].should eql("true")
    end
  end
end
