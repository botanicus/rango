# encoding: utf-8

Rango.import("exceptions")
Rango.import("loggers/logger")
Rango.import("bundling/dependency")
Rango.import("rack/middlewares/basic")

module Rango
  class << self
    # @since 0.0.1
    # @return [String] Returns current environment name. Possibilities are +development+ or +production+.
    attribute :environment, "development"

    # @since 0.0.2
    # @example
    #   Rango.path
    #   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
    # @return [Path] Rango root path
    def path
      @path ||= Path.new(self.root)
    end

    # @since 0.0.1
    # @example
    #   Rango.root
    #   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
    # @return [Rango::Logger] Logger for logging framework-related stuff. For logging project-relating stuff please use Project.logger.
    # @see Project::logger
    def logger
      @logger ||= Rango::Logger.new
    end

    # @since 0.0.1
    # @example
    #   Rango.boot(flat: true) # do not require anything
    #   Rango.boot # require init.rb
    #   Rango.boot { require_relative "config/init.rb" } # custom boot
    # @param [Hash] options You can specify flat: true for sinatra-like flat application.
    # @return [Boolean] Returns true if boot succeed or false if not. If ARGV includes "-i", IRB interactive session will start.
    def boot(options = Hash.new, &block)
      Rango.flat = true if options[:flat]
      Rango.import!("boot")
      block.call if block_given?
    end

    # @since 0.0.2
    def reboot(options = Hash.new)
      self.boot(options.merge(force: true))
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
    questionable :flat, false

    def debug=(boolean)
      $DEBUG = boolean
    end

    def debug?
      $DEBUG
    end

    def testing=(boolean)
      $TESTING = boolean
    end

    def testing?
      $TESTING
    end
  end
end
