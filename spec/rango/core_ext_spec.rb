# encoding: utf-8

require_relative "../spec_helper"

require "rango/core_ext"

describe ParamsMixin do
  describe ".convert" do
    it "should work" do
      mash = ParamsMixin.convert(key: "value")
      mash["key"].should eql("value")
    end

    it "should work recursively" do
      mash = ParamsMixin.convert(key: {inner: "value"})
      mash["key"].should_not be_nil
      mash["key"]["inner"].should eql("value")
    end
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

  describe "#keys" do
    it "should be array of strings" do
      object = Object.new
      hash   = {:a => 1, "b" => 2, object => 3}
      mash   = hash.extend(ParamsMixin)
      mash.keys.should eql(["a", "b", object])
    end
  end
end
