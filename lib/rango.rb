# coding=utf-8

require "ostruct"
require "rack"

root = File.join(File.dirname(__FILE__), "rango")
require File.join(root, "exceptions")
require File.join(root, "loggers", "logger")
require File.join(root, "ext", "core_ext")
require File.join(root, "version")

class Rango
  class << self
    attribute :flat, false

    # @since 0.0.1
    # @example
    #   Rango.framework.root
    #   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
    # @return [OpenStruct] OpenStruct with informations about the framework. Options are: <code>root</code>.
    # FIXME: when we install it through setup.rb, it will not copy stubs etc
    def framework
      root = File.join(File.dirname(__FILE__), "rango")
      framework = OpenStruct.new
      framework.root = root
      framework.path = Path.new(root)
      return framework
    end

    # @since 0.0.1
    # @example
    #   Rango.framework.root
    #   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
    # @return [Rango::Logger] Logger for logging framework-related stuff. For logging project-relating stuff please use Project.logger.
    # @see Project::logger
    def logger
      Rango::Logger.new
    end

    # @since 0.0.1
    # @example
    #   Rango.import("router")
    #   Rango.import("orm/adapters/#{Project.orm}", soft: true)
    # @param [String] path Relative path from lib/rango
    # @param [Hash] options Available options: soft
    # @raise [LoadError] Unless soft importing is enable, it will raise LoadError if the file wasn't found
    # @return [Boolean] Returns true if importing succeed or false if not.
    def import(path, options = Hash.new)
      if options[:soft]
        begin
          # TODO: load or require, the same as in Project
          require File.join(Rango.framework.root, path)
        rescue LoadError
          Rango.logger.warn("File #{path} can't be loaded")
          return false
        end
      else
        require File.join(Rango.framework.root, path)
      end
    end

    # @since 0.0.1
    # @example
    #   Rango.boot(flat: true)
    # @param [Hash] options You can specify flat: true for sinatra-like flat application.
    # @return [Boolean] Returns true if boot succeed or false if not. If ARGV includes "-i", IRB interactive session will start.
    def boot(options = Hash.new)
      begin
        Rango.flat = true if options[:flat]
        Rango.import("boot")
      rescue Exception => exception
        Rango.logger.exception(exception)
        return false
      end
    end

    # @since 0.0.2
    def app
      begin
        # $DEBUG = Project.settings.debug # It looks terrible, but rack works with it
        Rango.import("rack/dispatcher")
        Rack::Builder.new do
          # serve static files
          # http://rack.rubyforge.org/doc/classes/Rack/Static.html
          # use Rack::File.new(Project.settings.media_root)
          # use Rack::File, Project.settings.media_root
          use Rack::ContentLength
          use Rack::MethodOverride # _method: put etc
          use Rack::Reloader

          # TODO: MEDIA_PREFIX (rango, pupu, apache)

          Rango.import("rack/middlewares/static.rb")
          use Rango::Static
          use Rack::Session::Cookie, path: '/'
          #, key: 'rack.session', domain: 'foo.com', path: '/', expire_after: 2592000, secret: 'change_me'
          run ::Rango::Dispatcher.new
        end
      rescue Exception => exception
        Rango.logger.exception(exception)
        return false
      end
    end

    # Start IRB interactive session
    # @since 0.0.1
    def interactive
      require "irb"
      try_require "irb/completion" # some people can have ruby compliled without readline
      ARGV.clear # otherwise irb will read it
      IRB.start
    end

    # @since 0.0.1
    # @return [Boolean] If application is flat or not.
    def flat?
      @flat
    end
    
    def debug?
      true
    end
  end
end
