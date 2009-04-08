# coding=utf-8

Rango.import("templates/template")

class Rango
  class Controller
    include Rango::HttpExceptions
    include Rango::Helpers
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
      def before(action, options = Hash.new)
        self.before_filters[action] = options
      end

      # @since 0.0.2
      def after(action, options = Hash.new)
        self.after_filters[action] = options
      end

      # @since 0.0.2
      def run(request, params, method, *args)
        response = Rack::Response.new
        controller = self.new(request, params)
        controller.response = response
        # Rango.logger.inspect(before: ::Application.get_filters(:before), after: ::Application.get_filters(:after))
        # Rango.logger.inspect(before: get_filters(:before), after: get_filters(:after))
        controller.run_filters(:before, method)
        # If you don't care about arguments or if you prefer usage of params.
        if controller.method(method).arity.eql?(0)
          Rango.logger.info("Calling method #{method} without arguments")
          value = controller.method(method).call
        else
          Rango.logger.info("Calling method #{method} with arguments #{args.inspect}")
          value = controller.method(method).call(*args)
        end
        controller.run_filters(:after, method)
        response.body = value
        response.status = controller.status if controller.status
        response.headers.merge!(controller.headers)
        return response.finish
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
    def render(template, options = Hash.new)
      Rango::Templates::Template.new(template, self).render
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
    attribute :message, Hash.new

    # TODO
    # /foo/bar?msg[error]=Hello%20world%20bitch!
    # require "uri"
    # URI.escape("http://example.com/?a=\11\15")
    # @since 0.0.2
    def message
      self.params[:msg] || Hash.new
    end

    # @since 0.0.2
    def redirect(url, options = Hash.new)
      # TODO: encode options ito url
      # for example ?msg[error]=foo
      self.status = 302
      self.headers["Location"] = url
      return String.new
    end

    # @since 0.0.2
    def run_filters(name, method)
      # Rango.logger.debug(self.class.instance_variables)
      # Rango.logger.inspect(name: name, method: method)
      self.class.get_filters(name).each do |filter_method, options|
        begin
          unless options[:except] && options[:except].include?(method)
            if self.respond_to?(filter_method)
              Rango.logger.info("Calling filter #{filter_method} for controller #{self}")
              self.send(filter_method)
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