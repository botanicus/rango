# encoding: utf-8

require_relative "../spec_helper"
require "rango/exceptions"

describe Rango::Exceptions do
  before(:each) do
    @error = Rango::Exceptions::NotFound.new("Post with given ID doesn't exist")
  end

  describe "#status" do
    it "should returns HTTP status status" do
      @error.status.should eql(404)
    end
  end

  describe "#headers" do
    it "should returns HTTP status status" do
      @error.headers.should be_kind_of(Hash)
    end
  end

  describe "#to_snakecase" do
    it "should returns snakecased name of class" do
      @error.to_snakecase.should eql("not_found")
    end
  end

  describe "#to_response" do
    before(:each) do
      @status, @headers, @body = @error.to_response
    end

    it "should returns standard response array for Rack" do
      @status.should eql(@error.status)
    end

    it "should returns standard response array for Rack" do
      @headers.should be_kind_of(Hash)
    end

    it "should write Content-Type header" do
      @headers["Content-Type"].should_not be_nil
    end

    it "should returns standard response array for Rack" do
      @body.should respond_to(:each)
    end
  end
end
