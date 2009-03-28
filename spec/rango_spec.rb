# doesn't require spec helper, we do not need to init rango environment
specroot = File.dirname(__FILE__)
require File.join(specroot, "..", "lib", "rango")

describe Rango do
  it "should have version and codename" do
    Rango.codename.should be_kind_of(String)
    Rango.version.should be_kind_of(String)
    Rango.version.should match(/^\d+\.\d+\.\d+$/)
  end
  
  it "should not be flat by default" do
    Rango.should_not be_flat
  end
  
  it "should has logger" do
    Rango.logger.should be_kind_of(Rango::Logger)
  end
  
  describe ".framework" do
    it "should provides informations about framework root" do
      Rango.framework.should respond_to(:root)
      Rango.framework.root.should be_kind_of(String)
    end
  end
  
  describe ".import" do
    it "should import file from Rango if file exists" do
      pending "It returns false if file is already loaded. Of course, so fix API."
      Rango.import("core_ext").should be_true
    end
    
    it "should raise LoadError if file doesn't exist" do
      lambda { Rango.import("i_do_not_exist") }.should raise_error(LoadError)
    end
    
    it "should not raise LoadError if :soft => true" do
      lambda { Rango.import("i_do_not_exist", :soft => true) }.should_not raise_error(LoadError)
    end
  end
  
  describe ".boot" do
    # TODO
  end
end