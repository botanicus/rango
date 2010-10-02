# encoding: utf-8

require_relative "spec_helper"
require "rango"


describe Rango do
  it "should have logger" do
    Rango.logger.should respond_to?(:debug)
    Rango.logger.should respond_to?(:info)
    Rango.logger.should respond_to?(:warn)
    Rango.logger.should respond_to?(:error)
    Rango.logger.should respond_to?(:fatal)
  end

  # what about logger vs. extlib logger (fatal!)
  describe ".boot" do
    # TODO
  end
end
