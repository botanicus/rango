# encoding: utf-8

require "ostruct"
require "uri"
require "media-path"
require "rubyexts/logger"
require "rango/mixins/application"

rango_lib = File.dirname(__FILE__)
unless $:.include?(rango_lib) || $:.include?(File.expand_path(rango_lib))
  $:.unshift(rango_lib)
end

# It should solve problems with encoding in URL (flash messages) and templates
Encoding.default_internal = "utf-8"

module Rango
  VERSION ||= "0.1.0"
  extend ApplicationMixin

  def self.root
    File.join(File.dirname(__FILE__), "rango")
  end
end

require "rango/project"

module Rango
  # all the helpers are in Rango::Helpers
  # so if you want to register your own, just
  # Rango::Helpers.send(:include, Pupu::Helpers)
  Helpers ||= Module.new

  class << self
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
    # @return [RubyExts::Logger] Logger for logging framework-related stuff. For logging project-relating stuff please use Project.logger.
    # @see Project::logger
    def logger
      @logger ||= RubyExts::Logger.new
    end

    # @since 0.0.1
    # @example
    #   Rango.boot # require init.rb
    #   Rango.boot { require_relative "config/init.rb" } # custom boot
    # @param [Hash] options You can specify flat: true for sinatra-like flat application.
    # @return [Boolean] Returns true if boot succeed or false if not. If ARGV includes "-i", IRB interactive session will start.
    def boot(options = Hash.new, &block)
      self.environment = options[:environment] if options[:environment]
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
      require "rango/utils"
      ARGV.delete("-i") # otherwise irb will read it
      ENV["RACK_ENV"] = Rango.environment # for racksh
      unless try_require("racksh/boot")
        Rango.logger.info("For more goodies install racksh gem")
        try_require "irb/completion" # some people can have ruby compliled without readline
        Rango::Utils.load_rackup # so you can use Project.router etc
      end
      require "irb"
      require "rango/utils"
      IRB.start
    end
  end
end
