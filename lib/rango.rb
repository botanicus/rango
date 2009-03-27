require "ostruct"

root = File.join(File.dirname(__FILE__), "rango")
require File.join(root, "exceptions")
require File.join(root, "logger")
require File.join(root, "core_ext")

class Rango
  class << self
    # === Examples:
    # <pre>
    # Rango.framework.root
    # # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
    # </pre>
    #
    # @return [OpenStruct] OpenStruct with informations about the framework. Options are: <code>root</code>.
    def framework
      root = File.join(File.dirname(__FILE__), "rango")
      framework = OpenStruct.new
      framework.root = root
      return framework
    end

    # === Examples:
    # <pre>
    # Rango.framework.root
    # # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
    # </pre>
    #
    # @return [Rango::Logger] Logger for logging framework-related stuff. For logging project-relating stuff please use Project.logger.
    # @see Project::logger
    def logger
      Rango::Logger.new
    end

    # === Examples:
    # <pre>
    # Rango.import("router")
    # Rango.import("orm/adapters/#{Project.orm}", :soft => true)
    # </pre>
    #
    # @param [String] path Relative path from lib/rango
    # @param [Hash] options Available options: soft
    # @raise [LoadError] Unless soft importing is enable, it will raise LoadError if the file wasn't found
    # @return [Boolean] Returns true if importing succeed or false if not.
    def import(path, options = Hash.new)
      if options[:soft]
        begin
          require File.join(Rango.framework.root, path)
        rescue LoadError
          Rango.logger.warn("File #{path} can't be loaded")
          return false
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
  Rango.logger.exception(exception)
end

# irb
if ARGV.include?("-i")
  Rango.import("irb")
end
