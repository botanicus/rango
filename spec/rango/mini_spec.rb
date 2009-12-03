# encoding: utf-8

require_relative "../spec_helper"

require "rango/mini"
require "rack/mock"
require "rack/lint"

Rango::Router.use(:urlmap)

describe Rango::Mini do
  before(:each) do
    @app = Rango::Mini.app { "Hello Rack!" }
    @env = Rack::MockRequest.env_for("/")
  end

  it "should work standalone" do
    Rango::Mini.should respond_to(:app)
  end

  it "should work as a mixin" do
    controller = Class.new { include Rango::Mini }
    controller.new.should respond_to(:app)
  end

  it "should raise ArgumentError if no block given" do
    -> { Rango::Mini.app }.should raise_error(ArgumentError)
  end

  it "should be able to return valid rack application" do
    lint = Rack::Lint.new(@app)
    -> { lint.call(@env) }.should_not raise_error
  end

  it "should provide request as the first argument for given block" do
    Rango::Mini.app do |request, response|
      request.should be_kind_of(Rango::Request)
    end
  end

  it "should provide response as the second argument for given block" do
    Rango::Mini.app do |request, response|
      response.should be_kind_of(Rack::Response)
    end
  end

  it "should take returned value as a body" do
    status, headers, body = @app.call(@env)
    body.should eql("Hello Rack!")
  end

  describe "defaults" do
    it "should set status to HTTP 200 OK" do
      status, headers, body = @app.call(@env)
      status.should eql(200)
    end
  end
end
