# coding: utf-8

require File.join(Dir.pwd, "spec", "spec_helper")

describe Rango::Controller do
  it "should respond to request" do
    Factory.controller.should respond_to(:request)
  end

  it "should respond to params" do
    Factory.controller.should respond_to(:params)
  end

  it "should have logger" do
    Factory.controller.should respond_to(:logger)
    Factory.controller.logger.should eql(Project.logger)
  end
end