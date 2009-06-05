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

# from merb-core
class Rango
  module Chainable
    # Allows the definition of methods on a class that will be available via
    # super.
    #
    # ==== Examples
    #     class Foo
    #       extend Rango::Chainable
    #       chainable do
    #         def hello
    #           "hello"
    #         end
    #       end
    #     end
    #
    #     class Foo
    #       def hello
    #         super + " Merb!"
    #       end
    #     end
    #
    # # Example with mixin:
    # module TestMixin
    #   extend Rango::Chainable
    #   chainable do
    #     def test
    #       "from mixin!"
    #     end
    #   end
    # end
    #
    # class Test
    #   include TestMixin
    #   def test
    #     "hello " + super
    #   end
    # end
    #
    # puts Test.new.test
    #
    #
    # Foo.new.hello #=> "hello Merb!"
    #
    # ==== Parameters
    # &block::
    #   a block containing method definitions that should be
    #   marked as chainable
    #
    # ==== Returns
    # Module:: The anonymous module that was created
    def chainable(method = nil, &block)
      if method.nil? && block_given?
        mixin = Module.new(&block)
        include mixin
        return mixin
      elsif method && ! block_given?
        # TODO
        # def test
        #   # ...
        # end
        # chainable :test
      end
    end
  end
end
