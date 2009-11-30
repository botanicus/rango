# encoding: utf-8

require_relative "../spec_helper"

require "rango/gv"
require "rack/mock"

Rango::GV.define(:test_view) do |request, response, *args, &block|
  block ? block.call : "Hello from #{args.first || "GV"}!"
end

class TestController
  include Rango::GV::TestView
  def test_view(*args, &block) # TODO: it responds to request & response, how is it possible, it shouldn't
    "In controller: #{super(*args, &block)}"
  end
end

Rango::Router.use(:urlmap)

describe Rango::GV do
  before(:each) do
    @env = Rack::MockRequest.env_for("/")
  end

  describe ".test_view" do
    it "should create new method in the Rango::GV module with the same name as is the name of this generic view" do
      # it's not the same as Rango::GV::TestView, it's suited for router, so it log the event and call set_rack_env
      Rango::GV.should respond_to(:test_view)
    end
  end

  describe "Rango::GV::TestView" do
    it "should create a new module for it" do
      -> { Rango::GV::TestView }.should_not raise_error
    end

    it "should create new method in the new module with the same name as is the name of this generic view" do
      Rango::GV::TestView.should respond_to(:test_view)
    end

    it "should produce a Proc object" do
      Rango::GV::TestView.test_view.should respond_to(:call)
    end
  end

  it "should be able to create new generic view" do
    Rango::GV::TestView.test_view.call(@env).last.should eql("Hello from GV!")
    Rango::GV::test_view.call(@env).last.should eql("Hello from GV!")
  end

  it "should be able take arguments" do
    Rango::GV::TestView.test_view("my app").call(@env).last.should eql("Hello from my app!")
    Rango::GV::test_view("my app").call(@env).last.should eql("Hello from my app!")
  end

  it "should be able take a block" do
    Rango::GV::TestView.test_view { "block" }.call(@env).last.should eql("block")
    Rango::GV::test_view { "block" }.call(@env).last.should eql("block")
  end
  # check if render mixin is included

  describe "as a mixin" do
    before(:each) do
      @controller = TestController.new
    end

    it "should work" do
      @controller.test_view.should eql("In controller: Hello from GV!")
    end

    it "should work" do
      @controller.test_view("my app").should eql("In controller: Hello from my app!")
    end

    it "should work" do
      @controller.test_view { "block" }.should eql("In controller: block")
    end
  end
end

describe Rango::GV::Static do
end
