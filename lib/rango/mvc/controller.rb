# coding: utf-8

require "uri"
Rango.import("templates/template")
Rango.import("mixins/controller")

class Rango
  class Controller
    include Rango::HttpExceptions
    include Rango::Helpers
    include Rango::ControllerMixin
    include Rango::Templates::TemplateHelpers
    class << self
      # @since 0.0.2
      attribute :before_filters, Hash.new

      # @since 0.0.2
      attribute :after_filters,  Hash.new

      def inherited(subclass)
        Rango.logger.debug("Inheritting filters from #{self.inspect} to #{subclass.inspect}")
        subclass.before_filters = self.before_filters
        subclass.after_filters = self.after_filters
      end

      # before :login
      # before :login, actions: [:send]
      # @since 0.0.2
      def before(action = nil, options = Hash.new, &block)
        self.before_filters[action || block] = options
      end

      # @since 0.0.2
      def after(action = nil, options = Hash.new, &block)
        self.after_filters[action || block] = options
      end

      # @since 0.0.2
      def run(request, options = Hash.new, method = "index")
        response = Rack::Response.new
        controller = self.new(request, options.merge(request.params))
        controller.response = response
        # Rango.logger.inspect(before: ::Application.get_filters(:before), after: ::Application.get_filters(:after))
        # Rango.logger.inspect(before: get_filters(:before), after: get_filters(:after))
        controller.run_filters(:before, method)
        # If you don't care about arguments or if you prefer usage of params.
        args = controller.params.map { |key, value| value }
        if controller.method(method).arity.eql?(0)
          Rango.logger.info("Calling method #{method} without arguments")
          value = controller.method(method).call
        else
          Rango.logger.info("Calling method #{method} with arguments #{args.inspect}")
          value = controller.method(method).call(*args)
        end
        controller.run_filters(:after, method)
        response.body = proceed_value(value)
        response.status = controller.status if controller.status
        response.headers.merge!(controller.headers)
        return response.finish
      end
      
      def proceed_value(value)
        case value
        when true, false then value.to_s
        when nil then String.new
        else value
        end
      end
      
      def controller?
        true
      end

      # @since 0.0.2
      def get_filters(type)
        self.send("#{type}_filters")
      end
    end

    def initialize(request, params)
      @request = request
      @params  = params
      @cookies = request.cookies
      @session = request.session
      Rango.logger.inspect(params: params, cookies: cookies, session: session)
    end
    attr_reader :session

    def call
      # [master] Change Merb::Controller to respond to #call and return a Rack Array. (wycats)http://rubyurl.com/BhoY
    end
    
    # @since 0.0.2
    def run_filters(name, method)
      # Rango.logger.debug(self.class.instance_variables)
      # Rango.logger.inspect(name: name, method: method)
      self.class.get_filters(name).each do |filter_method, options|
        begin
          unless options[:except] && options[:except].include?(method)
            if filter_method.is_a?(Symbol) && self.respond_to?(filter_method)
              Rango.logger.info("Calling filter #{filter_method} for controller #{self}")
              self.send(filter_method)
            elsif filter_method.respond_to?(:call)
              Rango.logger.info("Calling filter #{filter_method.inspect} for controller #{self}")
              self.instance_eval(&filter_method)
            else
              Rango.logger.error("Filter #{filter_method} doesn't exists!")
            end
          end
        rescue SkipFilter
          Rango.logger.info("Skipping #{name} filter")
          next
        end
      end
    end
  end
end

# DEPRECATED IMPORTS
# Rango.import("auth/core")
# Rango.import("auth/more")
