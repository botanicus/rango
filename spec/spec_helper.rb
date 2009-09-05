# encoding: utf-8

SPEC_ROOT = File.dirname(__FILE__)
require "spec" # so you can run ruby spec/rango/whatever_spec.rb
require File.join(SPEC_ROOT, "..", "lib", "rango")
require File.join(SPEC_ROOT, "factories.rb")

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
      Matcher.new :match, expected do |expected|
        match do |actual|
          actual.match(expected)
        end
      end
    end
  end
end
