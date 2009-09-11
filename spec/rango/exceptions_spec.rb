# encoding: utf-8

require_relative "../spec_helper"

describe Rango::HttpError do
  before(:each) do
    @error = Rango::NotFound.new("Post with given ID doesn't exist")
  end

  describe "constants" do
    it "should has CONTENT_TYPE" do
      Rango::HttpError.constants.should include(:CONTENT_TYPE)
    end
    
    it "should xxxxxxxxx" do
      @class  = Class.new(Rango::HttpError)
      -> { @class::STATUS }.should raise_error(NameError, /has to have defined constant STATUS/)
    end
  end

  describe "#status" do
    it "should returns HTTP status status" do
      @error.status.should eql(404)
    end
  end

  describe "#content_type" do
    it "should returns HTTP status status" do
      @error.content_type.should eql(@error.class::CONTENT_TYPE)
    end

    it "should returns HTTP status status" do
      @error.content_type = "text/xml"
      @error.content_type.should eql("text/xml")
    end
  end

  describe "#headers" do
    it "should returns HTTP status status" do
      @error.headers.should be_kind_of(Hash)
    end

    it "should returns HTTP status status" do
      @error.headers = "text/xml"
      @error.headers.should eql("text/xml")
    end
  end

  describe "#to_snakecase" do
    it "should returns snakecased name of class" do
      @error.to_snakecase.should eql("not_found")
    end
  end
  
  describe "#to_reponse" do
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
      @headers["Content-Type"].should eql @error.content_type
    end

    it "should returns standard response array for Rack" do
      @body.should respond_to(:each)
    end
  end
end
