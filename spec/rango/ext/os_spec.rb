# encoding: utf-8

require_relative "../../../lib/rango/ext/os"

describe OS do
  before(:each) do
    @os = OS.new(home: "/Users/botanicus", path: "/bin:/sbin")
  end

  describe ".parse" do
    it "should transform 'KEY' => value syntax into key: value" do
      @os = OS.parse("HOME" => "/Users/botanicus", "PATH" => "/bin:/sbin")
    end

    it "should use ENV by default" do
      ENV.should eql(OS.parse.original_env)
    end

    it "should save original ENV" do
      OS.parse.original_env.should eql(ENV)
    end
  end

  describe "basic variables" do
    before(:each) do
      @os = OS.new(@os.env.merge(empty: "", digit: "123"))
    end

    it "should be shortcut for ENV['variable']" do
      @os.home.should eql("/Users/botanicus")
    end

    it "should returns array of paths if key ends with PATH or LIB" do
      @os.path.should eql(["/bin", "/sbin"])
    end

    it "should convert empty string to nil" do
      @os.empty.should be_nil
    end

    it "should convert string '123' to integer 123" do
      @os.digit.should eql(123)
    end
  end

  describe "#[]" do
    it "should returns value for given key if key exist" do
      @os[:home].should eql("/Users/botanicus")
    end

    it "should returns nil if given key doesn't exist" do
      @os[:xpath].should be_nil
    end
  end

  describe "#==" do
    it "should be equal if keys and values are equal" do
      one = OS.new(home: "/Users/botanicus", path: "/bin:/sbin")
      two = OS.new(home: "/Users/botanicus", path: "/bin:/sbin")
      one.should == two
    end

    it "should be equal if keys and sorted values are equal" do
      one = OS.new(home: "/Users/botanicus", path: "/sbin:/bin")
      two = OS.new(home: "/Users/botanicus", path: "/bin:/sbin")
      one.should == two
    end

    it "should not be equal if keys are equal but values not" do
      one = OS.new(home: "/Users/one", path: "/bin:/sbin")
      two = OS.new(home: "/Users/two", path: "/bin:/sbin")
      one.should_not == two
    end

    it "should not be equal if keys are different" do
      one = OS.new(home: "/Users/one")
      two = OS.new(home: "/Users/two", path: "/bin:/sbin")
      one.should_not == two
    end
  end

  describe "#keys" do
    it "should returns array of ENV keys which are upcased strings" do
      @os.keys.should be_kind_of(Array)
      @os.keys.all? { |key| key.should be_kind_of(Symbol) }
      @os.keys.all? { |key| key.should match(/^[a-z_]+$/) }
    end
  end

  describe "#inspect" do
    it "should show all the keys" do
      [:home, :path].each do |key|
        @os.inspect.should match(%r[#{key}])
      end
    end
  end

  describe "#root?" do
    it "should returns false if user isn't root" do
      @os.should_not be_root
    end

    it "should returns true if user is root" do
      pending do
        @os.should be_root
      end
    end
  end

  describe "#method_missing" do
    it "should returns nil if method doesn't exist and no arguments or block given" do
      @os.i_do_not_exist.should be_nil
    end

    it "should raise NoMethodError nil if method doesn't exist and no arguments or block given" do
      -> { @os.i_do_not_exist {}    }.should raise_error(NoMethodError)
      -> { @os.i_do_not_exist(1)    }.should raise_error(NoMethodError)
      -> { @os.i_do_not_exist(1) {} }.should raise_error(NoMethodError)
    end
  end
end
