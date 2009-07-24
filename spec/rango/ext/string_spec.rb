# encoding: utf-8

require_relative "../../../lib/rango/ext/string"

describe String do
  describe "#titlecase" do
    it "should returns titlecased string" do
      "hello world!".titlecase.should eql("Hello World!")
    end

    it "should play well with unicode" do
      pending do
        "čus borče!".titlecase.should eql("Čus Borče!")
      end
    end
  end
end
