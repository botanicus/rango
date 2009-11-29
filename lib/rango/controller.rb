# encoding: utf-8

# http://wiki.github.com/botanicus/rango/controllers

require "rango/mixins/render"
require "rango/exceptions"
require "rango/project"
require "rango/rack/request"
require "rango/router"
require "rango/templates/template"

module Rango
  class Controller
    include Rango::Helpers
    include Rango::RenderMixin
    include Rango::Templates::TemplateHelpers

    class << self
      # @since 0.0.2
      attribute :before_filters, Hash.new

      # @since 0.0.2
      attribute :after_filters,  Hash.new

      def inherited(subclass)
        inherit_filters(subclass, :before)
        inherit_filters(subclass, :after)
        inherit_filters(subclass, :before_render)
        inherit_filters(subclass, :after_render)
        inherit_filters(subclass, :before_display)
        inherit_filters(subclass, :after_display)
      end

      def inherit_filters(subclass, name)
        subclass.send("#{name}_filters=", self.send("#{name}_filters").dup)
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

      attribute :before_render_filters, Array.new
      attribute :after_render_filters, Array.new

      attribute :before_display_filters, Array.new
      attribute :after_display_filters, Array.new

      # [master] Change Merb::Controller to respond to #call and return a Rack Array. (wycats)http://rubyurl.com/BhoY
      # @since 0.0.2
      def call(env)
        Rango::Router.new.set_rack_env(env) # See rango/router/adapters/*
        request = Rango::Request.new(env)
        options = env["rango.router.params"] || raise("rango.router.params property has to be setup at least to empty hash")
        method = env["rango.controller.action"].to_sym
        controller = self.new(request, options.merge(request.params))
        begin
          unless controller.respond_to?(method) # TODO: what about method_missing?
            raise NotFound, "Controller #{self.name} doesn't have method #{method}"
          end
          controller.run_filters(:before, method.to_sym)
          # If you don't care about arguments or if you prefer usage of params.
          if controller.method(method).arity.eql?(0)
            Rango.logger.debug("Calling method #{self.name}##{method} without arguments")
            controller.response.body = controller.method(method).call
          else
            args = controller.params.values
            Rango.logger.debug("Calling method #{self.name}##{method} with arguments #{args.inspect}")
            controller.response.body = controller.method(method).call(*args)
          end
          controller.run_filters(:after, method)
          return controller.response.finish
        rescue HttpError => exception
          controller.rescue_http_error(exception)
        end
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
      def dispatcher(action)
        lambda do |env|
          Rango.logger.info("Dispatching to #{self}##{action} [#{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}]")
          env["rango.controller.action"] = action
          return self.call(env)
        end
      end

      # @since 0.0.2
      def get_filters(type)
        self.send("#{type}_filters")
      end
    end

    def initialize(request, params)
      @request = request
      @response = Rack::Response.new
      @params  = params
      @cookies = request.cookies
      @session = request.session
      Rango.logger.inspect(params: params, cookies: cookies, session: session)
    end
    attr_reader :session

    def route_to(action, params = Hash.new)
      self.class.route_to(request.env, action, params)
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

    # @since 0.0.2
    def run_filters(name, method)
      # Rango.logger.debug(self.class.instance_variables)
      # Rango.logger.inspect(name: name, method: method)
      self.class.get_filters(name).each do |filter_method, options|
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
      end
    end
  end
end
