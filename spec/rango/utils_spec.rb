# encoding: utf-8

require_relative "../spec_helper"

require "rack/lint"
require "rack/mock"
require "rango/utils"

describe Rango::Utils do
  it "should work as a mixin, so we can include it into our app mixin and redefine it" do
    Class.new { extend Rango::Utils }.should respond_to(:load_rackup)
  end

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
      Dir.chdir(File.join(Dir.pwd, "spec", "stubs")) do
        Rango::Utils.load_rackup
      end
    end
  end
end
