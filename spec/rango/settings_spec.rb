# encoding: utf-8

require File.join(Dir.pwd, "spec", "spec_helper")

describe Rango::Settings do
  before(:each) do
    @settings = Rango::Settings::Framework.new
  end

  it "should can merge one settings with another" do
    # TODO
  end

  it "should can merge! one settings with another" do
    # TODO
  end

  it "should log message if anyone tries to write nonexisting property" do
    # TODO
    @settings.foobar = "something"
  end

  describe Rango::Settings::Framework do
    # TODO
  end
end