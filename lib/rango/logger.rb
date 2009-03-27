require "logger"

# TODO: dedit z loggeru, napsat lepe, moznost ovlivnovat konfiguraci
# TODO: logger.debug("watch this:", @object)
# TODO: logger.debug(object: @object)

class Rango
  class Logger < Logger
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
      self.error(exception.message)
      exception.backtrace.each do |line|
        # TODO: general, safe solution for filtering backtraces
        unless line.match(/thin|eventmachine/)
          STDERR.puts("- #{line.colorize.cyan}")
        end
      end
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
