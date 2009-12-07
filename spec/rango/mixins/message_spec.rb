# encoding: utf-8

require_relative "../../spec_helper"

require "rack/mock"
require "rango/controller"
require "rango/mixins/message"
require "rango/mixins/rendering"

class TestController < Rango::Controller
  include Rango::MessageMixin
end

describe Rango::MessageMixin do
  before(:each) do
    @env = Rack::MockRequest.env_for("/?msg")
    @controller = TestController.new(@env)
  end

  describe ".included" do
    it "should not do anything if method locals isn't defined" do
      pending "How to implement it?"
      @controller.should_not respond_to(:locals)
    end

    class ExplicitRenderingController < Rango::Controller
      include Rango::ExplicitRendering
      include Rango::MessageMixin
    end

    it "should add message to locals if method locals is defined" do
      controller = ExplicitRenderingController.new(@env)
      controller.locals.should have_key(:message)
    end
  end

  describe "#message" do
    before(:each) do
      @env = Rack::MockRequest.env_for("/")
    end

    it "should" do
      @env["QUERY_STRING"] = "msg=Hello%20There%21"
      controller = TestController.new(@env)
      controller.message.should eql("Hello There!")
    end

    it "should" do
      @env["QUERY_STRING"] = "msg%5Berror%5D%3DHello%20There%21"
      controller = TestController.new(@env)
      controller.message[:error].should eql("Hello There!")
    end

    it "should" do
      @env["QUERY_STRING"] = "msg%5Berror%5D=Hello%20There%21&msg%5Bnotice%5D=Welcome%21"
      controller = TestController.new(@env)
      controller.message[:error].should eql("Hello There!")
      controller.message[:notice].should eql("Welcome!")
    end
  end

  describe "#redirect" do
    before(:each) do
      @env  = Rack::MockRequest.env_for("/")
      Posts = Class.new(Rango::Controller) { include Rango::MessageMixin }
      @controller = Posts.new(@env)
    end

    it "should be satisfied just with url" do
      @controller.redirect("/")
      @controller.status.should eql(302)
      @controller.headers["Location"].should eql("http://example.org/")
    end

    it "should be satisfied just with url" do
      @controller.redirect("/", "Try again")
      @controller.headers["Location"].should eql("http://example.org/?msg=Try%20again")
    end

    it "should be satisfied just with url" do
      @controller.redirect("/", error: "Try again")
      @controller.headers["Location"].should eql("http://example.org/?msg[error]=Try%20again")
    end
  end
end
