# encoding: utf-8

require_relative "../../../lib/rango/ext/os"

describe OS do
  describe "basic variables" do
    it "should be shortcut for ENV['variable']" do
      OS.home.should eql(ENV["HOME"])
    end
  end

  describe "variables ending with PATH or LIB" do
    it "should returns array of paths" do
      OS.path.should eql(ENV["PATH"].split(":"))
    end
  end
end
