# encoding: utf-8

# http://wiki.github.com/botanicus/rango/controllers

require "forwardable"
require "rango/router"
require "rango/exceptions"
require "rango/rack/request"
require "rango/environments"

module Rango
  class Controller
    include Rango::UrlHelper
    include Rango::Exceptions
    extend Forwardable
    # for routers
    def self.dispatcher(action)
      lambda do |env|
        Rango.logger.info("Dispatching to #{self}##{action} [#{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}]")
        env["rango.controller.action"] = action
        return self.call(env)
      end
    end

    # [master] Change Merb::Controller to respond to #call and return a Rack Array. (wycats)http://rubyurl.com/BhoY
    # @since 0.0.2
    def self.call(env)
      Rango::Router.set_rack_env(env) # TODO: this shouldn't require router stuff, it might emit an event
      controller = self.new(env)
      controller.to_response
    end

    def run_action
      if self.respond_to?(self.action)
        self.invoke_action(self.action)
      else
        raise NotFound, "Controller #{self.class.name} doesn't have method #{self.action}"
      end
    end

    # default, redefine in plugin if you need to
    def invoke_action(action)
      Rango.logger.debug("Calling method #{self.class.name}##{action} without arguments")
      self.response.body = self.send(action)
    end

    def action
      env["rango.controller.action"].to_sym
    rescue NoMethodError
      raise "You have to setup env['rango.controller.action'] to name of action you want to call"
    end

    def to_response
      self.run_action
      #self.response.finish # do we need this?
      [response.status, response.headers, [response.body]] # this way we got real body rather than response object
    rescue Redirection => redirection
      redirection.to_response
    rescue HttpError => exception
      self.rescue_http_error(exception)
    rescue Exception => exception # so we can be sure that all the exceptions which occures in controller can be captured by rescue_http_error method
      if Rango.development?
        raise exception
      else
        message = "#{exception.class}: #{exception.message}"
        server_error = InternalServerError.new(message)
        server_error.backtrace = caller
        self.rescue_http_error(server_error)
      end
    end

    # @since 0.0.1
    # @return [#debug, #info, #error, #fatal, #flush, #close] Logger for logging project related stuff.
    def logger
      Rango.logger
    end

    def_delegators :response, :status, :status=
    def_delegators :response, :headers, :headers=

    # absolute_uri "http://google.com" => "http://google.com"
    # absolute_uri "/products" => "http://localhost:4000/products"
    def absolute_uri(path)
      if path.match(/^https?:\/{2}/)
        path
      else
        (request.base_url.chomp("/") + path).chomp("/")
      end
    end

    # @since 0.0.2
    # @version 0.2.1
    # @return [String] Escaped URL (which is RFC recommendation)
    def redirect(location, status = 303, &block)
      if (300..399).include?(status)
        exception = Redirection.new(absolute_uri(location))
        exception.status = status
        exception.headers["Set-Cookie"] = response["Set-Cookie"] # otherwise it don't save cookies
        block.call(exception) unless block.nil?
        raise exception
      else
        raise ArgumentError, "Status has to be between 300 and 399"
      end
    end

    attr_reader :env
    def initialize(env)
      @env = env
    end

    def request
      @request ||= Rango::Request.new(env)
    end

    def response
      @response ||= Rack::Response.new
    end

    def_delegators :request, :cookies, :session

    def router_params
      @router_params ||= begin
        params = self.env["rango.router.params"]
        raise "rango.router.params property has to be setup at least to empty hash" if params.nil?

        symbolize_keys = lambda do |hash|
          hash.reduce(Hash.new) do |hash, pair|
            if pair.last.is_a?(Hash)
              hash.merge(pair.first.to_sym => symbolize_keys.call(pair.last))
            else
              hash.merge(pair.first.to_sym => pair.last)
            end
          end
        end

        symbolize_keys.call(params)
      end
    end

    def params
      @params ||= self.request.params.merge(self.router_params).symbolize_keys
    end

    # redefine this method for your controller if you want to provide custom error pages
    # returns response array for rack
    # if you need to change just body of error message, define render_http_error method
    # @api plugin
    def rescue_http_error(exception)
      # we need to call it before we assign the variables
      body = self.render_http_error(exception)
      [exception.status, exception.headers, body]
    end

    def render_http_error(exception)
      "EXCEPTION"
    end
  end
end
