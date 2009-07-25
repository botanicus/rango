# encoding: utf-8

require_relative "../../../lib/rango/ext/random"

describe "Array#random" do
  before(:each) do
    @array = (1..1000).to_a
  end

  it "should returns random item *from array*" do
    @array.should include(@array.random)
  end

  it "should returns *random* item from array" do
    @array.random.should_not eql(@array.random)
  end
end

describe "Range#random" do
  before(:each) do
    @range = (1..1000)
  end

  it "should returns random item *from range*" do
    @range.should include(@range.random)
  end

  it "should returns *random* item from range" do
    @range.random.should_not eql(@range.random)
  end
end
