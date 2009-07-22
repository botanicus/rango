# encoding: utf-8

require_relative "../../../lib/rango/ext/hash"

describe Hash do
  before(:each) do
    @hash = {"one" => 1, "two" => {"inner" => 3}}
    @one  = {class: "post", id: 12}
    @two  = {class: "post", id: 14}
  end

  describe "#symbolize_keys" do
    it "should transform keys into symbols" do
      @hash.symbolize_keys.should eql(one: 1, two: {"inner" => 3})
    end
  end

  describe "#symbolize_keys!" do
    it "should transform keys into symbols" do
      @hash.symbolize_keys!
      @hash.should eql(one: 1, two: {"inner" => 3})
    end
  end

  describe "#deep_symbolize_keys" do
    it "should transform keys into symbols" do
      @hash.deep_symbolize_keys.should eql(one: 1, two: {inner: 3})
    end
  end

  describe "#deep_symbolize_keys!" do
    it "should transform keys into symbols" do
      @hash.deep_symbolize_keys!
      @hash.should eql(one: 1, two: {inner: 3})
    end
  end

  describe "#extract!" do
    it "should returns just values for given keys" do
      hash = {foo: "bar"}.merge(@one)
      hash.extract!(:id, :foo).should eql([12, "bar"])
    end
  end

  describe "#to_html_attrs" do
    it "should convert hash into URL format" do
      @one.to_html_attrs.should eql("class='post' id='12'")
    end
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
