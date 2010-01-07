# encoding: utf-8

require "rango/mixins/chainable"

module Rango
  module MessageMixin
    # The rails-style flash messages
    # @since 0.0.2
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
          end
        end
      else
        Rango.logger.warn("Context method isn't defined")
      end
    end

    def message
      @message ||= (request.GET[:msg] || Hash.new)
    end

    # @since 0.0.2
    def redirect(url, options = Hash.new)
      url = [self.request.base_url.chomp("/"), url].join("/").chomp("/") unless url.match(/^http/)

      if options.respond_to?(:inject)
        # redirect "/post", error: "Try again"
        # ?msg[error]="Try again"
        url = options.inject(url) do |url, pair|
          type, message = pair
          url + "?msg[#{type}]=#{message}"
        end
      else
        # redirect "/post", "Try again"
        # ?msg="Try again"
        url.concat("?msg=#{options}")
      end

      self.status = 302
      self.headers["Location"] = URI.escape(url)
      return String.new
    end
  end
end
