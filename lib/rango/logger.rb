require "logger"

# TODO: dedit z loggeru, napsat lepe, moznost ovlivnovat konfiguraci
# TODO: logger.debug("watch this:", @object)
# TODO: logger.debug(object: @object)

class Rango
  class Logger
    attr_accessor :logger
    def initialize
      self.logger = ::Logger.new(STDERR)
      self.setup
    end

    def setup
      logger.level = ::Logger::DEBUG
      logger.datetime_format = "%H:%M:%S"
      self.setup_format
    end

    def setup_format
      logger.formatter = lambda do |severity, datetime, progname, msg|
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
