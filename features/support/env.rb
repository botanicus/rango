# encoding: utf-8

require "tempfile"
require "spec/expectations"
require "fileutils"
require "forwardable"

require_relative "../../lib/rango/ext"

class RangoWorld
  extend Forwardable
  def_delegators RangoWorld, :tmp, :rango_lib_dir

  def self.tmp_dir(*subdirs)
    File.join("/tmp/rango", *subdirs)
  end

  def rango_lib_dir
    @rango_lib_dir ||= File.expand_path(File.join(File.dirname(__FILE__), "../../lib"))
  end

  def initialize
    @tmp_dir = self.class.tmp_dir # TODO: platform independent
  end

  private
  attr_reader :last_exit_status, :last_stdout, :last_stderr

  def create_file(file_name, file_content)
    file_content.gsub!("CUCUMBER_LIB", "'#{rango_lib_dir}'") # Some files, such as Rakefiles need to use the lib dir
    in_tmp_dir do
      File.open(file_name, "w") { |f| f << file_content }
    end
  end

  def tmp(*subdirs, &block)
    path = File.join("/tmp/rango", *subdirs)
    Dir.chdir(path, &block)
  end

  def run(command)
    stderr_file = Tempfile.new("cucumber")
    stderr_file.close
    tmp do
      @last_stdout = `#{command} 2> #{stderr_file.path}`
      @last_exit_status = $?.exitstatus
    end
    @last_stderr = IO.read(stderr_file.path)
  end

  def rango(*args)
    args = args.map { |arg| arg.to_s.match(/\s/) ? "'#{arg}'" : arg }.join(" ")
    system "bin/rango #{args} &> /dev/null"
  end
end

World do
  RangoWorld.new
end

Before do
  FileUtils.rm_rf RangoWorld.tmp_dir
  FileUtils.mkdir RangoWorld.tmp_dir
end
