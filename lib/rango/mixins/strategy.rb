# encoding: utf-8

# Include this module to strategy superclass
module Rango
  module StrategyMixin
    class << self
      attribute :strategies, Array.new

      def register
        self.strategies.push(self)
      end

      def find(*args)
        self.strategies.find { |strategy| strategy.match?(*args) }
      end
    end

    def match?(*args)
      raise "This method must be redefined in subclasses"
    end

    def run(*args)
      raise "This method must be redefined in subclasses"
    end

    # define setup method if you need it
  end
end
