# encoding: utf-8

require_relative "../../../lib/rango/ext/os"

describe OS do
  describe "basic variables" do
    before(:each) do
      @os = OS.new(home: "/Users/botanicus", path: "/bin:/sbin")
    end

    it "should be shortcut for ENV['variable']" do
      @os.home.should eql("/Users/botanicus")
    end
  end

  describe "variables ending with PATH or LIB" do
    it "should returns array of paths" do
      @os.path.should eql(["/bin", "/sbin"])
    end
  end
end
