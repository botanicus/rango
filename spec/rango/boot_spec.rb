specroot = File.join(File.dirname(__FILE__), "..")
require File.join(specroot, "spec_helper")

describe Rango do
  describe ".environment" do
    it "should have environment" do
      Rango.should respond_to(:environment)
    end
    
    it "should be development by default" do
      Rango.environment.should eql("development")
    end
  end
  
  describe ".dependency" do
    # TODO
  end
end