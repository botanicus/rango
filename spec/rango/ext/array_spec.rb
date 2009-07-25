# encoding: utf-8

require_relative "../../../lib/rango/ext/array"

describe Array do
  describe "#only" do
    it "should returns the only item in array" do
      [:first].only.should eql(:first)
    end

    it "should raise index error if array has more items" do
      -> { [1, 2].only }.should raise_error(IndexError)
    end

    it "should returns the only item in array" do
      -> { Array.new.only }.should raise_error(IndexError)
    end
  end
end
