# encoding: utf-8

require_relative "../../lib/rango/ext"

describe Kernel do
  before(:each) do
    dirname = File.dirname(__FILE__)
    @path   = File.join(dirname, "..", "stubs")
    @path   = File.expand_path(@path)
  end
  
  describe "#acquire" do
    before(:each) do
      $:.push(@path) unless $:.include?(@path)
    end

    it "should raise LoadError if given directory doesn't exist at all" do
      -> { acquire "a/b/c/d" }.should raise_error(LoadError)
    end
    
    it "should returns empty array if no file match the glob, but the base directory exist" do
      loaded = acquire "acqs/*.i"
      loaded.should be_kind_of(Array)
      loaded.should be_empty
    end

    it "should returns nonempty array if some files matched the glob" do
      loaded = acquire "acqs/**/*"
      loaded.should be_kind_of(Array)
      loaded.should_not be_empty
    end
    
    it "should returns array with full paths" do
      loaded = acquire "acqs/**/*"
      loaded.each do |file|
        File.file?(file).should be_true
        File.expand_path(file).should eql(file)
      end
    end

    it "should require all files responding to given glob" do
      loaded = acquire "acqs/**/*"
      loaded.should include("lib.rb")
      loaded.should include("dir/lib.rb")
    end

    it "should ignore dotfiles" do
      loaded = acquire "acqs/**/*"
      loaded.should_not include(".hidden.rb")
    end
    
    it "should ignore nonruby files" do
      loaded = acquire "acqs/**/*"
      loaded.should_not include("tasks.thor")
    end

    it "should permit to exclude a file" do
      loaded = acquire "acqs/**/*", exclude: "dir/lib.rb"
      loaded.should     include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude array of files" do
      loaded = acquire "acqs/**/*", exclude: ["lib.rb", "dir/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude a glob" do
      loaded = acquire "acqs/**/*", exclude: "**/*_spec.rb"
      loaded.should     include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end
    
    it "should permit to exclude list of globs" do
      loaded = acquire "acqs/**/*", exclude: ["**/*_spec.rb", "**/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end

    it "should expand path" do
      pending
      # loaded = acquire "~/"
    end
  end
  
  describe "#acquire_relative" do
    it "should raise LoadError if given directory doesn't exist at all" do
      -> { acquire_relative "a/b/c/d" }.should raise_error(LoadError)
    end
    
    it "should returns empty array if no file match the glob, but the base directory exist" do
      loaded = acquire_relative "../stubs/acqs/*.i"
      loaded.should be_kind_of(Array)
      loaded.should be_empty
    end

    it "should returns nonempty array if some files matched the glob" do
      loaded = acquire_relative "../stubs/acqs/**/*"
      loaded.should be_kind_of(Array)
      loaded.should_not be_empty
    end
    
    it "should returns array with full paths" do
      loaded = acquire_relative "../stubs/acqs/**/*"
      loaded.each do |file|
        File.file?(file).should be_true
        File.expand_path(file).should eql(file)
      end
    end

    it "should require all files responding to given glob" do
      loaded = acquire_relative "../stubs/acqs/**/*"
      loaded.should include("lib.rb")
      loaded.should include("dir/lib.rb")
    end

    it "should ignore dotfiles" do
      loaded = acquire_relative "../stubs/acqs/**/*"
      loaded.should_not include(".hidden.rb")
    end
    
    it "should ignore nonruby files" do
      loaded = acquire_relative "../stubs/acqs/**/*"
      loaded.should_not include("tasks.thor")
    end

    it "should permit to exclude a file" do
      loaded = acquire_relative "../stubs/acqs/**/*", exclude: "dir/lib.rb"
      loaded.should     include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude array of files" do
      loaded = acquire_relative "../stubs/acqs/**/*", exclude: ["lib.rb", "dir/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
    end

    it "should permit to exclude a glob" do
      loaded = acquire_relative "../stubs/acqs/**/*", exclude: "**/*_spec.rb"
      loaded.should     include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end
    
    it "should permit to exclude list of globs" do
      loaded = acquire_relative "../stubs/acqs/**/*", exclude: ["**/*_spec.rb", "**/lib.rb"]
      loaded.should_not include("lib.rb")
      loaded.should_not include("dir/lib.rb")
      loaded.should_not include("dir/lib_spec.rb")
    end

    it "should expand path" do
      pending
      # loaded = acquire_relative "~/"
    end
  end
end
