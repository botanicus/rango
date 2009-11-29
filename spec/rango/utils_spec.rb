# encoding: utf-8

require_relative "../spec_helper"

require "rack/lint"
require "rack/mock"
require "rango/utils"

describe Rango::Utils do
  describe ".load_rackup" do
    it "should take path to rackup as the first argument" do
      rackup = File.join("spec", "stubs", "config.ru")
      -> { Rango::Utils.load_rackup(rackup) }.should_not raise_error(ArgumentError)
    end

    it "should return rack application" do
      rackup = File.join("spec", "stubs", "config.ru")
      lint   = Rack::Lint.new(Rango::Utils.load_rackup(rackup))
      env    = Rack::MockRequest.env_for("/")
      -> { lint.call(env) }.should_not raise_error
    end

    it "should take config.ru in current directory as the default path" do
      current_directory = Dir.pwd
      Dir.stub!(:pwd).and_return(File.join(current_directory, "spec", "stubs"))
      Rango::Utils.load_rackup
    end
  end
end
