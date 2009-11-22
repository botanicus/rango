# encoding: utf-8

require "rango/exceptions"
require "rango/loggers/logger"
require "rango/rack/middlewares/basic"
require "rango/project"

module Rango
  # all the helpers are in Rango::Helpers
  # so if you want to register your own, just
  # Rango::Helpers.send(:include, Pupu::Helpers)
  Helpers ||= Module.new

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
      @path ||= MediaPath.new(self.root)
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
    #   Rango.boot # require init.rb
    #   Rango.boot { require_relative "config/init.rb" } # custom boot
    # @param [Hash] options You can specify flat: true for sinatra-like flat application.
    # @return [Boolean] Returns true if boot succeed or false if not. If ARGV includes "-i", IRB interactive session will start.
    def boot(options = Hash.new, &block)
      self.environment = options[:environment] unless options[:environment]
      require "rango/boot"
      block.call if block_given?
      self.bootloaders.each do |name, bootloader|
        logger.debug "Calling bootloader #{name}"
        bootloader.call
      end
    end

    # @since 0.0.2
    def reboot(options = Hash.new)
      self.boot(options.merge(force: true))
    end

    attribute :bootloaders, Hash.new
    def after_boot(name, &block)
      self.bootloaders[name] = block
    end

    # Start IRB interactive session
    # @since 0.0.1
    def interactive
      ARGV.delete("-i") # otherwise irb will read it
      try_require("racksh") || Rango.logger.info("For more goodies install racksh gem")
      require "irb"
      require "rango/testing" # so you can load_rackup
      try_require "irb/completion" # some people can have ruby compliled without readline
      IRB.start
    end

    # clever environments support
    attribute :development_environments, ["development", "test", "spec", "cucumber"]
    attribute :testing_environments, ["test", "spec", "cucumber"]
    attribute :production_environments, ["stage", "production"]

    questionable :testing,     lambda { self.testing_environments.include?(Rango.environment) }
    questionable :development, lambda { self.development_environments.include?(Rango.environment) }
    questionable :production,  lambda { self.production_environments.include?(Rango.environment) }

    def environment?(environment)
      self.environment.eql?(environment.to_sym)
    end
  end
end
