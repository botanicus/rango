# encoding: utf-8

require_relative "../../../lib/rango/ext/object_space"

describe ObjectSpace do
  describe "#classes" do
    it "should returns the only item in array" do
      -> { Class.new }.should change { ObjectSpace.classes.length }.by(1)
    end

    it "should returns the only item in array" do
      ObjectSpace.classes.each do |klass|
        klass.should be_kind_of(Class)
      end
    end
  end
end
