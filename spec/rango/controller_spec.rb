specroot = File.join(File.dirname(__FILE__), "..")
require File.join(specroot, "spec_helper")

describe Rango::Controller do
  it "should respond to request" do
    Rango.should respond_to(:request)
  end
  
  it "should respond to params" do
    Rango.should respond_to(:params)
  end
  
  it "should respond to logger" do
    Rango.should respond_to(:logger)
  end
end