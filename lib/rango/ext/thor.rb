# encoding: utf-8

require "thor"

# Hooks
# Rango::Tasks.hook do
#   Dir["models/*.rb"].each(&method(:require))
# end
class Rango
  class Tasks < Thor
    class << self
      attr_accessor :hooks
      def hook(&block)
        @hooks ||= Array.new
        @hooks.push(block)
      end

      def inherited(subclass)
        subclass.hooks = self.hooks
      end
    end

    def boot(*args)
      require "rango"
      Rango.boot(*args)
      p self.class.hooks
      self.class.hooks.each(&:call)
    rescue Exception => exception
      Rango.logger.exception(exception)
    end
  end
end
