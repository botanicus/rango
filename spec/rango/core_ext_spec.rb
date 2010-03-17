# encoding: utf-8

require_relative "../spec_helper"

require "rango/core_ext"

describe ParamsMixin do
  describe ".convert" do
  end

  describe "getter & setter" do
    before(:each) do
      @mash = {key: "value"}.extend(ParamsMixin)
    end

    it "should work with a string as a key" do
      @mash["key"].should eql("value")
    end

    it "should work with a symbol as a key" do
      @mash[:key].should eql("value")
    end

    it "should not cause any issues if the key isn't a string nor a symbol" do
      object = Object.new
      lambda {
        @mash[object] = "test"
        @mash[object].should eql("test")
      }.should_not raise_error
    end

    it "should set the value with key if key is a string" do
      @mash["key"] = "changed"
      @mash[:key].should eql("changed")
    end

    it "should set the value with key if key is a symbol" do
      @mash[:key] = "changed"
      @mash["key"].should eql("changed")
    end
  end
end
