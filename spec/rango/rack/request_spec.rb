# encoding: utf-8

require_relative "../../spec_helper"
require "rango/rack/request"

describe Rango::Request do
  describe "#params" do
    before(:each) do
      env = Rack::MockRequest.env_for("/?ssl=true")
      @request = Rango::Request.new(env)
    end

    it "should have indifferent access" do
      @request.params[:ssl].should  eql("true")
      @request.params["ssl"].should eql("true")
    end
  end
end
