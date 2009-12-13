# encoding: utf-8

if RUBY_VERSION < "1.9.1"
  raise "Rango requires at least Ruby 1.9.1. If you run JRuby, please ensure you used the --1.9 switch for JRuby command."
end

rango_lib = File.dirname(__FILE__)
unless $:.include?(rango_lib) || $:.include?(File.expand_path(rango_lib))
  $:.unshift(rango_lib)
end

# It should solve problems with encoding in URL (flash messages) and templates
Encoding.default_internal = "utf-8"

module Rango
  # all the helpers are in Rango::Helpers
  # so if you want to register your own, just
  # Rango::Helpers.send(:include, Pupu::Helpers)
  Helpers ||= Module.new

  def self.root=(root)
    @@root = root
  end

  def self.root
    @@root ||= Dir.pwd
  end

  def self.media_root=(media_root)
    @@media_root = media_root
  end

  def self.media_root
    @@media_root ||= File.join(self.root, "media")
  end

  def self.logger
    @@logger
  rescue
    raise NameError, "You have to assign a logger to Rango.logger"
  end

  def self.logger=(logger)
    require "rango/mixins/logger"
    @@logger = logger.extend(LoggerMixin)
  end

  # @since 0.0.1
  # @example
  #   Rango.boot # require init.rb
  #   Rango.boot { require_relative "config/init.rb" } # custom boot
  # @param [Hash] options You can specify flat: true for sinatra-like flat application.
  # @return [Boolean] Returns true if boot succeed or false if not. If ARGV includes "-i", IRB interactive session will start.
  def self.boot(options = Hash.new, &block)
    self.environment = options[:environment] if options[:environment]
    block.call if block_given?
    self.bootloaders.each do |name, bootloader|
      # logger.debug "Calling bootloader #{name}"
      bootloader.call
    end
  end

  # @since 0.0.2
  def self.reboot(options = Hash.new)
    self.boot(options.merge(force: true))
  end

  def self.bootloaders
    @@bootloaders
  end

  @@bootloaders = Hash.new

  def self.after_boot(name, &block)
    self.bootloaders[name] = block
  end

  # Rango.loaded?("environments.rb")
  def self.loaded?(relative_path) # would work just with Kernel#require, not with Kernel#load, I know that the name may be misleading, but better than required?
    full_path = File.expand_path(File.join(File.dirname(__FILE__), relative_path))
    $LOADED_FEATURES.any? { |file| file == full_path }
  end

  # Start IRB interactive session
  # @since 0.0.1
  def self.interactive
    require "irb"
    require "rango/utils"

    ARGV.delete("-i") # otherwise irb will read it
    ENV["RACK_ENV"] = Rango.environment # for racksh
    unless try_require("racksh/boot")
      Rango.logger.info("For more goodies install racksh gem")
      try_require "irb/completion" # some people can have ruby compliled without readline
      Rango::Utils.load_rackup # so you can use Rango::Router.app etc
    end
    IRB.start
  end
end
