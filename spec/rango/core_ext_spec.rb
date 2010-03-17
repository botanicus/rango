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

    it "should work with strings" do
      @mash["key"].should eql("value")
    end

    it "should work with symbols" do
      @mash[:key].should eql("value")
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
