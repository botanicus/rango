# encoding: utf-8

Rango.import("mixins/controller")
Rango.import("helpers")

module Rango
  class Controller
    include Rango::Helpers
    include Rango::ControllerMixin
    include Rango::Templates::TemplateHelpers

    class << self
      # @since 0.0.2
      attribute :before_filters, Hash.new

      # @since 0.0.2
      attribute :after_filters,  Hash.new

      # @since 0.0.2
      attribute :autorendering, false

      def inherited(subclass)
        unless subclass.before_filters.empty? && subclass.after_filters.empty?
          Rango.logger.debug("Inheritting filters from #{self.inspect} to #{subclass.inspect} (before: #{subclass.before_filters.inspect}, after: #{subclass.after_filters.inspect})")
          subclass.before_filters = self.before_filters
          subclass.after_filters = self.after_filters
        end
        subclass.autorendering = self.autorendering
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

      # [master] Change Merb::Controller to respond to #call and return a Rack Array. (wycats)http://rubyurl.com/BhoY
      # @since 0.0.2
      def call(env)
        Rango::Router.new.set_rack_env(env) # See rango/router/adapters/*
        request = Rango::Request.new(env)
        options = env["rango.router.params"] || raise("rango.router.params property has to be setup at least to empty hash")
        method = options[:action] || :index
        response = Rack::Response.new
        controller = self.new(request, options.merge(request.params))
        controller.response = response
        Rango.logger.info("#{self.name}.call(env) with method #{method}")
        # Rango.logger.inspect(before: ::Application.get_filters(:before), after: ::Application.get_filters(:after))
        # Rango.logger.inspect(before: get_filters(:before), after: get_filters(:after))
        controller.run_filters(:before, method.to_sym)
        # If you don't care about arguments or if you prefer usage of params.
        args = controller.params.map { |key, value| value }
        if controller.method(method).arity.eql?(0)
          Rango.logger.info("Calling method #{self.name}##{method} without arguments")
          value = controller.method(method).call
        else
          Rango.logger.info("Calling method #{self.name}##{method} with arguments #{args.inspect}")
          value = controller.method(method).call(*args)
        end
        controller.autorender if self.autorendering
        controller.run_filters(:after, method)
        response.body = proceed_value(value)
        response.status = controller.status if controller.status
        response.headers.merge!(controller.headers)
        return response.finish
      rescue HttpError => exception
        rescue_http_error(exception)
      end

      # redefine this method for your controller if you want to provide custom error pages
      # returns response array for rack
      # if you need to change just body of error message, define render_http_error method
      # @api plugin
      def rescue_http_error(exception)
        if self.respond_to?(:render_http_error)
          message = self.render_http_error(exception)
          exception.message = message unless message.nil?
        end
        exception.to_response
      end

      # @experimental
      def route_to(env, action, params = Hash.new)
        env["rango.controller"] = self
        env["rango.controller.action"] = action
        env["rango.router.params"] = params
        env["rango.action"] = action
        Rango::Router::Dispatcher.route_to(env, self)
      end

      # for routers
      def self.dispatcher(action)
        lambda do |env|
          env["rango.controller.action"] = action
          return self.call(env)
        end
      end

      def proceed_value(value)
        case value
        when true, false then value.to_s
        when nil then String.new
        else value
        end
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

    def route_to(action, params = Hash.new)
      self.class.route_to(request.env, action, params)
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
