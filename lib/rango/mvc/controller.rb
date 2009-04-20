# coding: utf-8

Rango.import("templates/template")

class Rango
  class Controller
    include Rango::HttpExceptions
    include Rango::Helpers
    include Rango::Templates::TemplateHelpers
    class << self
      # @since 0.0.2
      attribute :before_filters, Hash.new

      # @since 0.0.2
      attribute :after_filters,  Hash.new

      # @since 0.0.2
      attribute :template_prefix, ""

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

    # @since 0.0.1
    # @return [Rango::Request]
    # @see Rango::Request
    attr_accessor :request, :params, :cookies, :response

    def initialize(request, params)
      @request = request
      @params  = params
      @cookies = request.cookies
      @session = request.session
      Rango.logger.inspect(params: params, cookies: cookies, session: session)
    end
    attr_reader :session

    # @since 0.0.1
    # @return [Hash] Hash with params from request. For example <code>{messages: {success: "You're logged in"}, post: {id: 2}}</code>
    attr_accessor :params

    attribute :status
    attribute :headers, Hash.new

    # @since 0.0.1
    # @return [Rango::Logger] Logger for logging project related stuff.
    # @see Rango::Logger
    attribute :logger, Project.logger

    # TODO: default option for template
    # @since 0.0.2
    def render(template, locals = Hash.new)
      Rango::Templates::Template.new(template, self, locals).render
    end

    # TODO: default option for template
    # @since 0.0.2
    def display(object, template, options = Hash.new)
      render(template)
    rescue Error406
      # TODO: provides API
      format = Project.settings.mime_formats.find do |format|
        object.respond_to?("to_#{format}")
      end
      format ? object.send("to_#{format}") : raise(Error406.new(self.params))
    end

    # The rails-style flash messages
    # @since 0.0.2
    def message
      @message ||= (request.GET[:msg] || Hash.new)
    end

    # @since 0.0.2
    def redirect(url, options = Hash.new)
      self.status = 302

      # for example ?msg[error]=foo
      [:error, :success, :notice].each do |type|
        if msg = (options[type] || message[type])
          msg.tr!("čďěéíňóřšťúůýž", "cdeeinorstuuyz") # FIXME: encoding problem
          url.concat("?msg[#{type}]=#{msg}")
        end
      end

      require 'uri'
      self.headers["Location"] = URI.escape(url)
      return String.new
    end
    
    def capture(&block)
      raise "Rango::Controller#capture should be defined in your template engine adapter"
    end
    
    # view:
    # render "index"
    # template:
    # extends "base.html" if layout
    # This is helper can works as render layout: false for AJAX requests when you probably would like to render just the page without layout
    def layout
      request.ajax?
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

Rango.import("auth/core")
Rango.import("auth/more")