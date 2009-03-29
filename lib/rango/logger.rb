# coding=utf-8

# TODO: documentation
# TODO: specs
require "logger"

class Rango
  class Logger < ::Logger
    def initialize(output = STDERR)
      super(output)
      self.setup
    end

    def setup
      self.level = ::Logger::DEBUG
      self.datetime_format = "%H:%M:%S"
      self.setup_format
    end
    
    def exception(exception)
      self.error("#{exception.message} (#{exception.class})")
      exception.backtrace.each do |line|
        unless line.match(/thin|eventmachine/)
          STDERR.puts("- #{line.colorize.cyan}")
        end
      end
    end

    # Logger methods can takes more arguments and they returns array with arguments
    # NOTE: why we dup args each time? Because we colorize messages, but if logger method
    # is used for handling requests, we just need to send noncolored messages as response.
    def debug(*args)
      original = args.dup
      args.map { |arg| super(arg) }
      return original
    end
    
    def info(*args)
      original = args.dup
      args.map { |arg| super(arg) }
      return original
    end
    
    def warn(*args)
      original = args.dup
      args.map { |arg| super(arg) }
      return original
    end
    
    def error(*args)
      original = args.dup
      args.map { |arg| super(arg) }
      return original
    end
    
    def fatal(*args)
      original = args.dup
      args.map { |arg| super(arg) }
      return original
    end
    
    # Project.logger.inspect(@posts, item)
    # Project.logger.inspect("@post" => @post)
    def inspect(*args)
      if args.first.is_a?(Hash) && args.length.eql?(1)
        args.first.each do |name, value|
          self.debug("#{name}: #{value.inspect}")
        end
      else
        args = args.map { |arg| arg.inspect }
        self.debug(*args)
      end
    end

    def setup_format
      self.formatter = lambda do |severity, datetime, progname, msg|
        # logger.debug(object_to_inspect)
        msg = msg.inspect unless msg.is_a?(String)
        case severity
        when "DEBUG" then "#{datetime}: #{msg.colorize.green}\n"
        when "INFO"  then "#{datetime}: #{msg.colorize.cyan}\n"
        when "WARN"  then "#{datetime}: #{msg.colorize.yellow}\n"
        when "ERROR" then "#{datetime}: #{msg.colorize.red}\n"
        when "FATAL" then "#{datetime}: #{msg.colorize.red.colorize.bold}\n"
        end
      end
    end
  end
end
