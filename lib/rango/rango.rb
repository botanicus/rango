# coding: utf-8

Rango.import("exceptions")
Rango.import("loggers/logger")
Rango.import("version")

class Rango
  class << self
    attribute :flat, false

    # @since 0.0.2
    # @example
    #   Rango.path
    #   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
    # @return [Path] Rango root path
    def path
      Path.new(self.root)
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
        Rack::Builder.new { run ::Rango::Dispatcher.new }
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
