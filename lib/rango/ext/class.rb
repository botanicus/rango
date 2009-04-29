# coding: utf-8

# class Test
#   extend Rango::Hookable
#   install_hook do |instance|
#     p instance
#   end
#   
#   def initialize
#     p self
#   end
# end
# 
# Test.new

class Rango
  module Hookable
    def new(*args)
      instance = super(*args)
      self.hooks.each { |hook| hook.call(instance) }
      return instance
    end

    def hooks
      @hooks ||= Array.new
    end

    def install_hook(&block)
      self.hooks.push(block)
    end
  end  
end
