# encoding: utf-8

require_relative "../../../lib/rango/ext/file"

# TODO: don't test everything in $HOME
describe File do
  before(:each) do
    @token = rand(360 ** 50).to_s(36)
    @path  = File.join("~", @token)
  end

  after(:each) do
    FileUtils.rm(File.expand_path(@path), force: true)
    FileUtils.rm(File.expand_path("#{@path}.rw"), force: true)
  end

  describe ".puts" do
    it "should write each argument as a line" do
      path = File.puts(@path, "first", "second")
      File.read(path).should eql("first\nsecond\n")
    end
  end

  describe ".print" do
    it "should write all arguments without any extra whitespaces" do
      path = File.print(@path, "first", "second")
      File.read(path).should eql("firstsecond")
    end
  end

  describe ".append" do
    it "should works like File.puts for new files" do
      path = File.append(@path, "first", "second")
      File.read(path).should eql("first\nsecond\n")
    end

    it "should append all arguments separated by \\n" do
      File.puts(@path, "first")
      path = File.append(@path, "second")
      File.read(path).should eql("first\nsecond\n")
    end
  end

  describe ".add" do
    it "should works like File.print for new files" do
      path = File.add(@path, "first", "second")
      File.read(path).should eql("firstsecond")
    end

    it "should append all arguments without any extra whitespaces" do
      File.print(@path, "first")
      path = File.add(@path, "second")
      File.read(path).should eql("firstsecond")
    end
  end

  describe ".write" do
    it "should expand file path" do
      File.write(:puts, "w", @path, "content")
      File.exist?(File.expand_path(@path)).should be_true
    end

    it "should returns expanded file path" do
      File.write(:puts, "w", @path, "test").should eql(File.expand_path(@path))
    end

    it "should use first argument as method sended to file" do
      first  = File.puts("#{@path}.rw", "first", "second")
      second = File.write(:puts, "w", @path, "first", "second")
      File.read(first).should eql(File.read(second))
    end

    it "should use 3..n arguments as arguments of given method" do
      path = File.write(:printf, "w", @path, "%d %04x", 123, 123)
      File.read(path).should eql("123 007b")
    end
  end
end
