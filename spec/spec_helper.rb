# encoding: utf-8

SPEC_ROOT  = File.dirname(__FILE__)
STUBS_ROOT = File.join(SPEC_ROOT, "stubs")

$:.unshift(File.join(SPEC_ROOT, "..", "lib"))

begin
  # Require the preresolved locked set of gems.
  require File.expand_path("../.bundle/environment", __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require "spec" # so you can run ruby spec/rango/whatever_spec.rb

require "rango"
require "logger"
Rango.logger = Logger.new("/dev/null")

class RecursiveOpenStruct < OpenStruct
  def initialize(attributes = Hash.new)
    attributes.each do |key, value|
      if value.is_a?(Hash)
        attributes[key] = OpenStruct.new(value)
      end
    end
    super(attributes)
  end
end

module Spec
  module Matchers
    def match(expected)
      Matcher.new(:match, expected) do |expected|
        match do |actual|
          actual.match(expected)
        end
      end
    end
  end
end

Spec::Runner.configure do |config|
  config.before(:all) do
    Rango.environment = "test"
  end
end
