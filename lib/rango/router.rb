# encoding: utf-8

require "rango" # for helpers

module Rango
  module Exceptions
    class RouterNotInitialized < StandardError; end
  end

  module UrlHelper
    # url(:login)
    def url(*args)
      raise NotImplementedError, "Your router or your router adapter doesn't support this method"
    end
  end

  Helpers.send(:include, UrlHelper)

  class Router
    @@routers ||= Hash.new
    def self.app
      @@app
    rescue NameError
      raise Exceptions::RouterNotInitialized, "You have to assign your router application to Rango::Router.app\nFor example Rango::Router.app = Usher::Interface.for(:rack, &block)"
    end

    def self.app=(app)
      @@app = app
    end

    def self.router
      @@router
    rescue NameError
      raise "You have to run Rango::Router.use(router_name) first!"
    end

    def self.router=(router)
      @@router = router
    end

    def self.implement(router, &block)
      @@routers[router] = block
    end

    def self.use(router)
      require_relative "router/adapters/#{router}"
      Rango.logger.debug("Using router #{router}")
      @@router = router
    end

    def self.set_rack_env(env)
      unless env["rango.router.params"]
        @@routers[self.router].call(env)
      end
    end
  end
end
