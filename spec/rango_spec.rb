# encoding: utf-8

# don't require spec helper, we do not need to init rango environment
require File.join(Dir.pwd, "lib", "rango")

describe Rango do
  it "should have version and codename" do
    Rango::CODENAME.should be_kind_of(String)
    Rango::VERSION.should be_kind_of(String)
    Rango::VERSION.should match(/^\d+\.\d+\.\d+$/)
  end

  it "should not be flat by default" do
    Rango.should_not be_flat
  end

  it "should has logger" do
    Rango.logger.should be_kind_of(Rango::Logger)
  end

  describe ".import" do
    it "should import file from Rango if file exists" do
      pending "It returns false if file is already loaded. Of course, so fix API."
      Rango.import("core_ext").should be_true
    end

    it "should raise LoadError if file doesn't exist" do
      -> { Rango.import("i_do_not_exist") }.should raise_error(LoadError)
    end

    it "should not raise LoadError if soft: true" do
      -> { Rango.import("i_do_not_exist", soft: true) }.should_not raise_error(LoadError)
    end
  end

  describe ".boot" do
    # TODO
  end
end
