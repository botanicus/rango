# encoding: utf-8

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
      if controller.method_defined?(:context)
        Rango.logger.debug("Extending context by message")
        controller.class_eval do
          include Module.new {
            def context
              @context ||= super.merge!(message: self.message)
            end
          }
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

    def redirect(uri, status = 303, options = Hash.new, &block)
      status, options = 303, status if status.is_a?(Hash)
      options.each { |type, message| flash[type] = message }
      super(uri, status)
    end
  end
end
