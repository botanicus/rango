# encoding: utf-8

require_relative "../../../lib/rango/ext/enumerable"

describe Enumerable do
  describe "#none?" do
    describe "withtout block" do
      it "should be true for empty collections " do
        Array.new.should be_none
        Hash.new.should be_none
      end

      it "should returns true for collections with just nils and false" do
        [nil].should be_none
        [false].should be_none
        [false, nil].should be_none
      end

      it "should returns false if collections contains some objects" do
        [1].should_not be_none
        {one: 1, two: 2}.should_not be_none
        {key: nil, other: false}.should_not be_none
      end
    end

    describe "with block" do
      describe "for array" do
        it "should returns false if all iteractions returns true" do
          array = Array.new(3) { Array.new }
          array.none? { |item| item.empty? }.should be_false
        end

        it "should returns true if all iteractions returns false" do
          array = Array.new(3) { [1] }
          array.none? { |item| item.empty? }.should be_true
        end
      end

      describe "for hash" do
        it "should returns false if all iteractions returns true" do
          hash = {key: Array.new, another: Hash.new, last: Array.new}
          hash.none? { |key, value| value.empty? }.should be_false
        end

        it "should returns true if all iteractions returns false" do
          hash = {key: [1], another: [2], last: [nil]}
          hash.none? { |item| item.empty? }.should be_true
        end
      end
    end
  end
end
