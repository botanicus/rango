# encoding: utf-8

module Rango
  module MessageMixin
    # The rails-style flash messages
    # @since 0.0.2
    # NOTE: it's important to include this mixin after ImplicitRendering mixin
    def self.included(controller)
      unless controller.method_defined?(:request)
        raise "Rango::MessageMixin requires method request to be defined"
      end
      controller.class_eval do
        if self.method_defined?(:context)
          Rango.logger.debug("Extending context by message")
          def context
            super.merge!(message: self.message)
          end
        else
          Rango.logger.warn("Context method isn't defined")
        end

        def redirect(uri, options = Hash.new, status = 303, &block)
          # status, options = 303, status if status.is_a?(Hash)
          if options.respond_to?(:inject)
            # redirect "/post", error: "Try again"
            # ?msg[error]="Try again"
            uri = options.inject(uri) do |uri, pair|
              type, message = pair
              uri + "?msg[#{type}]=#{message}"
            end
          else
            # redirect "/post", "Try again"
            # ?msg="Try again"
            uri.concat("?msg=#{options}")
          end
          super(uri, status)
        end
      end
    end

    def message
      @message ||= begin
        messages = request.GET[:msg] || String.new
        if messages.is_a?(String)
          messages.force_encoding(Encoding.default_external)
        elsif messages.is_a?(Hash)
          messages.inject(Hash.new.extend(ParamsMixin)) do |result, pair| # TODO: here is the problem, Hash.new isn't params mixin
            result.merge(pair[0] => pair[1].force_encoding(Encoding.default_external))
          end
        end
      end
    end
    alias_method :flash, :message
  end
end
