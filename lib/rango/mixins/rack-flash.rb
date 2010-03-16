# encoding: utf-8

require "rango/mixins/chainable"

# @see http://nakajima.github.com/rack-flash
# @example
#   use Rack::Flash
#   message["notice"]
#   flash["notice"]
#   OR
#   use Rack::Flash, accessorize: [:notice, :error]
#   message.notice
#   flash.notice
module Rango
  module RackFlashMixin
    # @since 0.2.4
    # NOTE: it's important to include this mixin after ImplicitRendering mixin
    def self.included(controller)
      unless controller.method_defined?(:request)
        raise "Rango::MessageMixin requires method request to be defined"
      end
      if controller.method_defined?(:context)
        Rango.logger.debug("Extending context by message")
        controller.class_eval do
          extend Chainable
          chainable do
            def context
              super.merge!(message: self.message)
            end

            def redirect(uri, status = 303, options = Hash.new, &block)
              status, options = 303, status if status.is_a?(Hash)
              options.each { |type, message| flash[type] = message }
              super(uri, status)
            end
          end
        end
      else
        Rango.logger.warn("Context method isn't defined")
      end
    end

    def message
      @message ||= begin
        request.env["x-rack.flash"]
      end
    end
    alias_method :flash, :message
  end
end
