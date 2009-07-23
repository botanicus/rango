# encoding: utf-8

require_relative "../../lib/rango/ext"

describe Kernel do
  before(:each) do
    dirname = File.dirname(__FILE__)
    @path   = File.join(dirname, "..", "stubs")
    @path   = File.expand_path(@path)
    $LOADED_FEATURES.clear
  end

  def loaded
    $LOADED_FEATURES.map do |loaded|
      loaded.sub("#{@path}/acqs/", "")
    end
  end

  describe "#acquire" do
    before(:each) do
      $:.push(@path) unless $:.include?(@path)
    end

    it "should raise LoadError if given directory doesn't exist at all" do
      -> { acquire "a/b/c/d/*" }.should raise_error(LoadError)
    end

    it "should raise ArgumentError if given argument isn't a glob" do
      -> { acquire "a/b/c/d" }.should raise_error(ArgumentError)
    end

    it "should returns empty array if no file match the glob, but the base directory exist" do
      acquire "acqs/*.i"
      loaded.should be_kind_of(Array)
      loaded.should be_empty
    end

    it "should returns nonempty array if some files matched the glob" do
      acquire "acqs/**/*"
      loaded.should be_kind_of(Array)
      loaded.should_not be_empty
    end

    it "should returns array with full paths" do
      acquire "acqs/**/*"
      $LOADED_FEATURES.each do |file|
        File.file?(file).should be_true
        File.expand_path(file).should eql(file)
      end
    end

    it "should use .rb as default extension if any extension specified" do
      acquire "acqs/**/*"
      loaded.should     include("lib.rb")
      loaded.should     include("dir/lib.rb")
      loaded.should_not include("tasks.thor")
    end

    it "should load even files with another extension than just .rb" do
      acquire "acqs/**/*.thor"
      loaded.should     include("tasks.thor")
      loaded.should_not include("lib.rb")
    end

    it "should ignore dotfiles" do
      acquire "acqs/**/*"
      loaded.should_not include(".hidden.rb")
    end

    it "should ignore nonruby files" do
      acquire "acqs/**/*"
      loaded.should_not include("tasks.thor")
    end

    it "should permit to exclude a file" do
      acquire "acqs/**/*", exclude: "dir/lib.rb"
      loaded.should     include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude array of files" do
      acquire "acqs/**/*", exclude: ["lib.rb", "dir/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude a glob" do
      acquire "acqs/**/*", exclude: "**/*_spec.rb"
      loaded.should     include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end

    it "should permit to exclude list of globs" do
      acquire "acqs/**/*", exclude: ["**/*_spec.rb", "**/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end
  end

  describe "#acquire_relative" do
    before(:each) do
      $:.delete(@path)
    end

    it "should raise LoadError if given directory doesn't exist at all" do
      -> { acquire_relative "a/b/c/d/*" }.should raise_error(LoadError)
    end

    it "should raise ArgumentError if given argument isn't a glob" do
      -> { acquire_relative "a/b/c/d" }.should raise_error(ArgumentError)
    end

    it "should returns empty array if no file match the glob, but the base directory exist" do
      acquire_relative "../stubs/acqs/*.i"
      loaded.should be_kind_of(Array)
      loaded.should be_empty
    end

    it "should returns nonempty array if some files matched the glob" do
      acquire_relative "../stubs/acqs/**/*"
      loaded.should be_kind_of(Array)
      loaded.should_not be_empty
    end

    it "should returns array with full paths" do
      acquire_relative "../stubs/acqs/**/*"
      $LOADED_FEATURES.each do |file|
        File.file?(file).should be_true
        File.expand_path(file).should eql(file)
      end
    end

    it "should use .rb as default extension if any extension specified" do
      acquire_relative "../stubs/acqs/**/*"
      loaded.should     include("lib.rb")
      loaded.should     include("dir/lib.rb")
      loaded.should_not include("tasks.thor")
    end

    it "should load even files with another extension than just .rb" do
      acquire_relative "../stubs/acqs/**/*.thor"
      loaded.should     include("tasks.thor")
      loaded.should_not include("lib.rb")
    end

    it "should ignore dotfiles" do
      acquire_relative "../stubs/acqs/**/*"
      loaded.should_not include(".hidden.rb")
    end

    it "should ignore nonruby files" do
      acquire_relative "../stubs/acqs/**/*"
      loaded.should_not include("tasks.thor")
    end

    it "should permit to exclude a file" do
      acquire_relative "../stubs/acqs/**/*", exclude: "dir/lib.rb"
      loaded.should     include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude array of files" do
      acquire_relative "../stubs/acqs/**/*", exclude: ["lib.rb", "dir/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude a glob" do
      acquire_relative "../stubs/acqs/**/*", exclude: "**/*_spec.rb"
      loaded.should     include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end

    it "should permit to exclude list of globs" do
      acquire_relative "../stubs/acqs/**/*", exclude: ["**/*_spec.rb", "**/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end
  end
end
