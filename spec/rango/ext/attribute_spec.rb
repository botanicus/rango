# encoding: utf-8

require_relative "../../../lib/rango/ext/attribute"

describe AttributeMixin do
  describe "#private_alias" do
    before(:each) do
      @class = Class.new { private_alias :class }
    end

    it "should creates __alias__ of given method" do
      @class.new.tap do |instance|
        instance.class.should eql(instance.send(:__class__))
      end
    end

    it "should be private" do
      @class.private_instance_methods.should include(:__class__)
    end
  end

  describe "#attribute" do
    it
  end

  describe "#hattribute" do
    it
  end

  describe "#questionable" do
    it
  end

  describe "#default_hattribute_names" do
    it
  end
end
