# encoding: utf-8

require_relative "../../../lib/rango/ext/hash"

describe Hash do
  before(:each) do
    @one = {class: "post", id: 12}
    @two = {class: "post", id: 14}
  end

  describe "#to_url_attrs" do
    it "should convert hash into URL format" do
      @one.to_url_attrs.should eql("class=post&id=12")
    end
  end

  describe "#reverse_merge" do
    it "should returns result of merge the origin hash with first argument" do
      @one.reverse_merge(@two).should eql(class: "post", id: 12)
    end
  end

  describe "#reverse_merge!" do
    it "should replace hash by result of merge with first argument which" do
      @one.reverse_merge!(@two)
      @one.should eql(class: "post", id: 12)
    end
  end

  describe "#get" do
    before(:each) do
      @hash = {inner: @one}
    end

    it "should raise argument error any argument given" do
      -> { @hash.get }.should raise_error(ArgumentError)
    end

    it "should get item if the path exist" do
      @hash.get(:inner, :class).should eql("post")
    end

    it "should returns nil if the path doesn't exist" do
      @hash.get(:inner, :foobar).should be_nil
    end

    it "should raise index error if trying to work with non-hash-like object like hash" do
      -> { @hash.get(:inner, :class, :inner) }.should raise_error(IndexError)
    end
  end
end
