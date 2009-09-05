# encoding: utf-8

require "thor"
require "extlib"
require_relative "../ext"

# Hooks
# Rango::Tasks.hook do
#   Dir["models/*.rb"].each(&method(:require))
# end
module Rango
  class Tasks < Thor
    cattr_accessor :hooks
    @@hooks ||= Array.new

    def self.hook(&block)
      @@hooks.push(block)
    end

    def self.inherited(subclass)
      subclass.hooks = self.hooks
    end

    def boot(*args)
      require "rango"
      Rango.boot(*args)
      self.class.hooks.each(&:call)
    rescue Exception => exception
      Rango.logger.exception(exception)
    end
  end
end
