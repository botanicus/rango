require "ostruct"

root = File.join(File.dirname(__FILE__), "rango")
require File.join(root, "exceptions")
require File.join(root, "logger")
require File.join(root, "core_ext")

class Rango
  class << self
    def framework
      root = File.join(File.dirname(__FILE__), "rango")
      framework = OpenStruct.new
      framework.root = root
      return framework
    end

    def logger
      Rango::Logger.new.logger
    end

    # Rango.import("router")
    # Rango.import("router", :soft => true)
    def import(path, options = Hash.new)
      if options[:soft]
        begin
          require File.join(Rango.framework.root, path)
        rescue LoadError
          Rango.logger.warn("File #{path} can't be loaded")
        end
      else
        require File.join(Rango.framework.root, path)
      end
    end
  end
end

begin
  Rango.import("boot")
rescue Exception => exception
  # TODO: parse backtrace (another color for path, another for line and method)
  # TODO: maybe relative paths for project files will be better
  Rango.logger.error(exception.message)
  exception.backtrace.each do |line|
    puts "- #{line.colorize.cyan}"
  end
end

# irb
if ARGV.include?("-i")
  Rango.import("irb")
else
  # Rango.import("server")
  # Rango::Server.start(4000)
end
