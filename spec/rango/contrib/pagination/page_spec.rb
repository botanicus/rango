# encoding: utf-8

# version 1.0
require_relative "../../../spec_helper"
require "rango/contrib/pagination/page"

describe Page do
  before(:each) do
    @page = Page.new(count: 41, current: 4, per_page: 5)
  end

  describe "#initialize" do
    it "should setup current page to first page if something less than 1 is given" do
      page = Page.new(count: 41, current: 0, per_page: 5)
      page.number.should eql(1)
    end

    it "should setup current page to first page if nil is given" do
      page = Page.new(count: 41, current: nil, per_page: 5)
      page.number.should eql(1)
    end

    it "should setup current page to last page if something bigger than total count of pagegs is given" do
      page = Page.new(count: 41, current: 10, per_page: 5)
      page.number.should eql(9)
    end

    it "should raise argument error if params aren't hash" do
      -> { Page.new(1) }.should raise_error(ArgumentError)
    end

    it "should require just params[:count]" do
      -> { Page.new(count: 1) }.should_not raise_error(ArgumentError)
    end

    it "should have default values" do
      Page.new(count: 1).per_page.should eql(10)
      Page.new(count: 1).number.should eql(1)
    end
  end

  describe "#max" do
    it "should count pages total" do
      @page.max.should eql(9)
    end

    it "should count pages total" do
      page = Page.new(count: 40, current: 4, per_page: 5)
      page.max.should eql(8)
    end
  end

  describe "#next" do
    it "should be another object of Page" do
      @page.next.should be_kind_of(Page)
    end

    it "should count next as current plus one" do
      @page.next.number.should eql(@page.number + 1)
    end

    it "should returns nil if this is already the last one" do
      @page.number = 9
      @page.next.should be_nil
    end
  end

  describe "#previous" do
    it "should be another object of Page" do
      @page.previous.should be_kind_of(Page)
    end

    it "should count previous as current plus one" do
      @page.previous.number.should eql(@page.number - 1)
    end

    it "should returns nil if this is already the last one" do
      @page.number = 1
      @page.previous.should be_nil
    end
  end

  describe "#first" do
    it "should returns last page" do
      @page.first.number.should eql(1)
    end
  end

  describe "#last" do
    it "should returns last page" do
      @page.last.number.should eql(9)
    end
  end
end
